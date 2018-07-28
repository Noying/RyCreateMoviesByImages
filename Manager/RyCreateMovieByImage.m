//
//  RyCreateMovieByImage.m
//  CreateMovieByImage
//
//  Created by roy on 2018/7/24.
//  Copyright © 2018年 Iceroy. All rights reserved.
//

#import "RyCreateMovieByImage.h"
#import <libavformat/avformat.h>
#import <libavcodec/avcodec.h>


#define DATASIZE 1024*1024


@interface RyCreateMovieByImage()

@property (nonatomic,strong) NSArray *images;
@property (nonatomic) NSInteger Fps;

@end


@implementation RyCreateMovieByImage

-(void)setImages:(NSArray *)images{
    self.images = images;
}

-(void)setMovieImagesNumInOneSecond:(NSInteger)nums{
    self.Fps = nums;
}

-(id)createMoive{
    return nil;
}

-(void)saveMoiveByPath:(NSString *)urlPath{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString*path=[paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,urlPath];
    
    
    AVFormatContext *ofmt_ctx = NULL;//其包含码流参数较多，是一个贯穿始终的数据结构，很多函数都要用到它作为参数
    const char *out_filename = [filePath UTF8String];//输出文件路径，在这里也可以将mkv改成别的ffmpeg支持的格式，如mp4，flv，avi之类的
    int ret;//返回标志
    
    av_register_all();//初始化解码器和复用器
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, out_filename);//初始化一个用于输出的AVFormatContext结构体，视频帧率和宽高在此函数里面设置
    if (!ofmt_ctx)
    {
        NSLog(@"Could not create output context");
        return;
    }
    
    AVStream *out_stream = [self add_vidio_stream:ofmt_ctx AVCodeCID:AV_CODEC_ID_MJPEG];//创造输出视频流
    av_dump_format(ofmt_ctx, 0, out_filename, 1);//该函数会打印出视频流的信息，如果看着不开心可以不要
    
    if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE))//打开输出视频文件
    {
        ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            NSLog(@"Could not open output file '%s'", out_filename);
            return;
        }
    }
    
    if (avformat_write_header(ofmt_ctx, NULL) < 0)//写文件头（Write file header）
    {
        NSLog(@"Error occurred when opening output file");
        return;
    }
    
    int frame_index = 0;//放入视频的图像计数
    AVPacket pkt;
    av_init_packet(&pkt);
    pkt.flags |= AV_PKT_FLAG_KEY;
    pkt.stream_index = out_stream->index;//获取视频信息，为压入帧图像做准备
    while (frame_index<100)//将图像压入视频中
    {
        //打开一张jpeg图像并读取其数据，在这里图像最大为1M,如果超过1M，则需要修改1024*1024这里
        NSString *bundlePath =[[NSBundle mainBundle]pathForResource:@"1" ofType:@"jpg"];
        NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:bundlePath];
        NSData *myData = [fh readDataToEndOfFile];
        int length = [fh seekToEndOfFile];
        pkt.size = length;
        pkt.data = (uint8_t*)[myData bytes];
        if (av_interleaved_write_frame(ofmt_ctx, &pkt) < 0) //写入图像到视频
        {
            NSLog(@"Error muxing packet");
            break;
        }
        NSLog(@"Write %8d frames to output file", frame_index);//打印出当前压入的帧数
        frame_index++;
    }
    av_packet_unref(&pkt);//释放掉帧数据包对象
    av_write_trailer(ofmt_ctx);//写文件尾（Write file trailer）
    if (ofmt_ctx && !(ofmt_ctx->oformat->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);//关闭视频文件
    avformat_free_context(ofmt_ctx);//释放输出视频相关数据结构
}


/**
 用以初始化一个用于输出的AVFormatContext结构体

 @param oc 给予指针
 @param codec_id 编码格式
 @return AVStream流
 */
-(AVStream*)add_vidio_stream:(AVFormatContext *)oc AVCodeCID:(enum AVCodecID) codec_id{
    AVStream *st = nil;
    AVCodec *codec= nil;
    
    st = avformat_new_stream(oc, nil);
    NSAssert(st!=nil, @"Could not alloc stream");
    
    codec = avcodec_find_decoder(codec_id);
    NSAssert(codec!=nil, @"codec not found");
    
    avcodec_get_context_defaults3(st->codec, codec);//申请AVStream->codec(AVCodecContext对象)空间并设置默认值(由avcodec_get_context_defaults3()设置
    
    st->codec->bit_rate = 400000;//设置采样参数，即比特率
    st->codec->width = self.width;//设置视频宽高，这里跟图片的宽高保存一致即可
    st->codec->height = self.height;
    st->codec->time_base.den = self.Fps;//设置帧率
    st->codec->time_base.num = 1;
    
    st->codec->pix_fmt = AV_PIX_FMT_YUV420P;//设置像素格式
    st->codec->codec_tag = 0;
    if (oc->oformat->flags & AVFMT_GLOBALHEADER)//一些格式需要视频流数据头分开
        st->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
    return st;
}



@end
