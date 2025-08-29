Публичный bucket s3://neclud-otus-mlops
Terraform сделал с хранением state в s3 бакете и проверкой блокировки через ydb. Нужно делать с использованием модулей, конечно, но времени нет на реализацию, к сожалению
Цена master node 4 262,54 ₽ в месяц, каждой из data node 9 142,50 ₽ в месяц плюс трафик и т.п.
Возможные способы экономии - сделать VPC прерываемыми (т.е. они будут выключаться автоматически неболее, чем через сутки работы), тогда мастер будет стоить 1 774,22 ₽, дата нода 4 165,86 ₽, если это применимо. Также можно по данным мониторинга проанализировать потребляемые ресурсы, возможно, получится их уменьшить. Можно поставить 20% (или 50%) использование CPU, что также даст экономию. Экстрим вариант - запустить кластер на VPC вручную, т.е. не использовать его as a service. Наибольший эффект, вероятно, даст перевод VPC на прерываемые

Из бакета были скопированы файлы в hdfs (лог ниже) 

$ ssh -J ubuntu@158.160.62.25 ubuntu@192.168.1.8
$ bash upload_data_to_hdfs.sh
[Fri 29 Aug 2025 03:25:52 PM UTC] ----------------------------------------------------------
[Fri 29 Aug 2025 03:25:52 PM UTC] [INFO] No file name provided, copying all files
[Fri 29 Aug 2025 03:25:52 PM UTC] ----------------------------------------------------------
[Fri 29 Aug 2025 03:25:52 PM UTC] [INFO] Creating directory in HDFS
[Fri 29 Aug 2025 03:25:54 PM UTC] ----------------------------------------------------------
[Fri 29 Aug 2025 03:25:54 PM UTC] [INFO] Copying all data from S3 to HDFS
2025-08-29 15:25:56,221 INFO tools.DistCp: Input Options: DistCpOptions{atomicCommit=false, syncFolder=false, deleteMissing=false, ignoreFailures=false, overwrite=false, append=false, useDiff=false, useRdiff=false, fromSnapshot=null, toSnapshot=null, skipCRC=false, blocking=true, numListstatusThreads=0, maxMaps=20, mapBandwidth=0.0, copyStrategy='uniformsize', preserveStatus=[], atomicWorkPath=null, logPath=null, sourceFileListing=null, sourcePaths=[s3a://neclud-otus-mlops/], targetPath=/user/ubuntu/data, filtersFile='null', blocksPerChunk=0, copyBufferSize=8192, verboseLog=false, directWrite=false}, sourcePaths=[s3a://neclud-otus-mlops/], targetPathExists=true, preserveRawXattrsfalse
2025-08-29 15:25:56,512 INFO client.RMProxy: Connecting to ResourceManager at rc1a-dataproc-m-am3rujh2f985rur8.mdb.yandexcloud.net/192.168.1.8:8032
2025-08-29 15:25:56,696 INFO client.AHSProxy: Connecting to Application History server at rc1a-dataproc-m-am3rujh2f985rur8.mdb.yandexcloud.net/192.168.1.8:10200
2025-08-29 15:25:56,841 INFO impl.MetricsConfig: Loaded properties from hadoop-metrics2.properties
2025-08-29 15:25:56,920 INFO impl.MetricsSystemImpl: Scheduled Metric snapshot period at 10 second(s).
2025-08-29 15:25:56,920 INFO impl.MetricsSystemImpl: s3a-file-system metrics system started
2025-08-29 15:25:58,695 INFO tools.SimpleCopyListing: Paths (files+dirs) cnt = 41; dirCnt = 1
2025-08-29 15:25:58,695 INFO tools.SimpleCopyListing: Build file listing completed.
2025-08-29 15:25:58,697 INFO Configuration.deprecation: io.sort.mb is deprecated. Instead, use mapreduce.task.io.sort.mb
2025-08-29 15:25:58,697 INFO Configuration.deprecation: io.sort.factor is deprecated. Instead, use mapreduce.task.io.sort.factor
2025-08-29 15:25:58,775 INFO tools.DistCp: Number of paths in the copy list: 41
2025-08-29 15:25:58,823 INFO tools.DistCp: Number of paths in the copy list: 41
2025-08-29 15:25:58,840 INFO client.RMProxy: Connecting to ResourceManager at rc1a-dataproc-m-am3rujh2f985rur8.mdb.yandexcloud.net/192.168.1.8:8032
2025-08-29 15:25:58,841 INFO client.AHSProxy: Connecting to Application History server at rc1a-dataproc-m-am3rujh2f985rur8.mdb.yandexcloud.net/192.168.1.8:10200
2025-08-29 15:25:58,925 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/ubuntu/.staging/job_1756472470575_0008
2025-08-29 15:25:59,087 INFO mapreduce.JobSubmitter: number of splits:33
2025-08-29 15:25:59,236 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1756472470575_0008
2025-08-29 15:25:59,236 INFO mapreduce.JobSubmitter: Executing with tokens: []
2025-08-29 15:25:59,431 INFO conf.Configuration: resource-types.xml not found
2025-08-29 15:25:59,432 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
2025-08-29 15:25:59,517 INFO impl.YarnClientImpl: Submitted application application_1756472470575_0008
2025-08-29 15:25:59,652 INFO mapreduce.Job: The url to track the job: http://rc1a-dataproc-m-am3rujh2f985rur8.mdb.yandexcloud.net:8088/proxy/application_1756472470575_0008/
2025-08-29 15:25:59,652 INFO tools.DistCp: DistCp job-id: job_1756472470575_0008
2025-08-29 15:25:59,652 INFO mapreduce.Job: Running job: job_1756472470575_0008
2025-08-29 15:26:05,741 INFO mapreduce.Job: Job job_1756472470575_0008 running in uber mode : false
2025-08-29 15:26:05,742 INFO mapreduce.Job:  map 0% reduce 0%
2025-08-29 15:26:21,890 INFO mapreduce.Job:  map 5% reduce 0%
2025-08-29 15:26:23,917 INFO mapreduce.Job:  map 8% reduce 0%
2025-08-29 15:26:24,933 INFO mapreduce.Job:  map 9% reduce 0%
2025-08-29 15:26:25,943 INFO mapreduce.Job:  map 11% reduce 0%
2025-08-29 15:26:27,968 INFO mapreduce.Job:  map 12% reduce 0%
2025-08-29 15:28:13,673 INFO mapreduce.Job:  map 14% reduce 0%
2025-08-29 15:28:19,505 INFO mapreduce.Job:  map 15% reduce 0%
2025-08-29 15:28:32,574 INFO mapreduce.Job:  map 17% reduce 0%
2025-08-29 15:29:08,708 INFO mapreduce.Job:  map 21% reduce 0%
2025-08-29 15:29:26,772 INFO mapreduce.Job:  map 23% reduce 0%
2025-08-29 15:30:40,026 INFO mapreduce.Job:  map 24% reduce 0%
2025-08-29 15:30:50,080 INFO mapreduce.Job:  map 30% reduce 0%
2025-08-29 15:32:33,397 INFO mapreduce.Job:  map 42% reduce 0%
2025-08-29 15:33:12,528 INFO mapreduce.Job:  map 45% reduce 0%
2025-08-29 15:33:18,566 INFO mapreduce.Job:  map 48% reduce 0%
2025-08-29 15:33:22,577 INFO mapreduce.Job:  map 52% reduce 0%
2025-08-29 15:35:23,964 INFO mapreduce.Job:  map 55% reduce 0%
2025-08-29 15:35:54,056 INFO mapreduce.Job:  map 58% reduce 0%
2025-08-29 15:35:57,066 INFO mapreduce.Job:  map 70% reduce 0%
2025-08-29 15:36:01,077 INFO mapreduce.Job:  map 73% reduce 0%
2025-08-29 15:37:50,701 INFO mapreduce.Job:  map 76% reduce 0%
2025-08-29 15:38:12,768 INFO mapreduce.Job:  map 79% reduce 0%
2025-08-29 15:38:26,809 INFO mapreduce.Job:  map 82% reduce 0%
2025-08-29 15:39:34,669 INFO mapreduce.Job:  map 94% reduce 0%
2025-08-29 15:40:47,880 INFO mapreduce.Job:  map 100% reduce 0%
2025-08-29 15:42:25,200 INFO mapreduce.Job: Job job_1756472470575_0008 completed successfully
2025-08-29 15:42:27,150 INFO mapreduce.Job: Counters: 43
        File System Counters
                FILE: Number of bytes read=0
                FILE: Number of bytes written=8008331
                FILE: Number of read operations=0
                FILE: Number of large read operations=0
                FILE: Number of write operations=0
                HDFS: Number of bytes read=19521
                HDFS: Number of bytes written=120594553665
                HDFS: Number of read operations=418
                HDFS: Number of large read operations=0
                HDFS: Number of write operations=220
                HDFS: Number of bytes read erasure-coded=0
                S3A: Number of bytes read=120594553665
                S3A: Number of bytes written=0
                S3A: Number of read operations=81
                S3A: Number of large read operations=0
                S3A: Number of write operations=0
        Job Counters
                Launched map tasks=33
                Other local map tasks=33
                Total time spent by all maps in occupied slots (ms)=19836909
                Total time spent by all reduces in occupied slots (ms)=0
                Total time spent by all map tasks (ms)=6612303
                Total vcore-milliseconds taken by all map tasks=6612303
                Total megabyte-milliseconds taken by all map tasks=20312994816
        Map-Reduce Framework
                Map input records=41
                Map output records=0
                Input split bytes=4488
                Spilled Records=0
                Failed Shuffles=0
                Merged Map outputs=0
                GC time elapsed (ms)=19423
                CPU time spent (ms)=1635530
                Physical memory (bytes) snapshot=31641071616
                Virtual memory (bytes) snapshot=144471592960
                Total committed heap usage (bytes)=21632647168
                Peak Map Physical memory (bytes)=1070497792
                Peak Map Virtual memory (bytes)=4446343168
        File Input Format Counters
                Bytes Read=15033
        File Output Format Counters
                Bytes Written=0
        DistCp Counters
                Bandwidth in Btyes=662579300
                Bytes Copied=120594553665
                Bytes Expected=120594553665
                Files Copied=40
                DIR_COPY=1
2025-08-29 15:42:27,154 INFO impl.MetricsSystemImpl: Stopping s3a-file-system metrics system...
2025-08-29 15:42:27,154 INFO impl.MetricsSystemImpl: s3a-file-system metrics system stopped.
2025-08-29 15:42:27,154 INFO impl.MetricsSystemImpl: s3a-file-system metrics system shutdown complete.
[Fri 29 Aug 2025 03:42:27 PM UTC] ----------------------------------------------------------
[Fri 29 Aug 2025 03:42:27 PM UTC] [INFO] Listing files in HDFS directory
Found 40 items
-rw-r--r--   1 ubuntu hadoop 2807409271 2025-08-29 15:32 /user/ubuntu/data/2019-08-22.txt
-rw-r--r--   1 ubuntu hadoop 2854479008 2025-08-29 15:30 /user/ubuntu/data/2019-09-21.txt
-rw-r--r--   1 ubuntu hadoop 2895460543 2025-08-29 15:32 /user/ubuntu/data/2019-10-21.txt
-rw-r--r--   1 ubuntu hadoop 2939120942 2025-08-29 15:32 /user/ubuntu/data/2019-11-20.txt
-rw-r--r--   1 ubuntu hadoop 2995462277 2025-08-29 15:32 /user/ubuntu/data/2019-12-20.txt
-rw-r--r--   1 ubuntu hadoop 2994906767 2025-08-29 15:38 /user/ubuntu/data/2020-01-19.txt
-rw-r--r--   1 ubuntu hadoop 2995431240 2025-08-29 15:42 /user/ubuntu/data/2020-02-18.txt
-rw-r--r--   1 ubuntu hadoop 2995176166 2025-08-29 15:38 /user/ubuntu/data/2020-03-19.txt
-rw-r--r--   1 ubuntu hadoop 2996034632 2025-08-29 15:40 /user/ubuntu/data/2020-04-18.txt
-rw-r--r--   1 ubuntu hadoop 2995666965 2025-08-29 15:33 /user/ubuntu/data/2020-05-18.txt
-rw-r--r--   1 ubuntu hadoop 2994699401 2025-08-29 15:32 /user/ubuntu/data/2020-06-17.txt
-rw-r--r--   1 ubuntu hadoop 2995810010 2025-08-29 15:37 /user/ubuntu/data/2020-07-17.txt
-rw-r--r--   1 ubuntu hadoop 2995995152 2025-08-29 15:28 /user/ubuntu/data/2020-08-16.txt
-rw-r--r--   1 ubuntu hadoop 2995778382 2025-08-29 15:29 /user/ubuntu/data/2020-09-15.txt
-rw-r--r--   1 ubuntu hadoop 2995868596 2025-08-29 15:37 /user/ubuntu/data/2020-10-15.txt
-rw-r--r--   1 ubuntu hadoop 2995467533 2025-08-29 15:35 /user/ubuntu/data/2020-11-14.txt
-rw-r--r--   1 ubuntu hadoop 2994761624 2025-08-29 15:35 /user/ubuntu/data/2020-12-14.txt
-rw-r--r--   1 ubuntu hadoop 2995390576 2025-08-29 15:30 /user/ubuntu/data/2021-01-13.txt
-rw-r--r--   1 ubuntu hadoop 2995780517 2025-08-29 15:42 /user/ubuntu/data/2021-02-12.txt
-rw-r--r--   1 ubuntu hadoop 2995191659 2025-08-29 15:30 /user/ubuntu/data/2021-03-14.txt
-rw-r--r--   1 ubuntu hadoop 2995446495 2025-08-29 15:28 /user/ubuntu/data/2021-04-13.txt
-rw-r--r--   1 ubuntu hadoop 3029170975 2025-08-29 15:35 /user/ubuntu/data/2021-05-13.txt
-rw-r--r--   1 ubuntu hadoop 3042691991 2025-08-29 15:35 /user/ubuntu/data/2021-06-12.txt
-rw-r--r--   1 ubuntu hadoop 3041980335 2025-08-29 15:29 /user/ubuntu/data/2021-07-12.txt
-rw-r--r--   1 ubuntu hadoop 3042662187 2025-08-29 15:42 /user/ubuntu/data/2021-08-11.txt
-rw-r--r--   1 ubuntu hadoop 3042455173 2025-08-29 15:38 /user/ubuntu/data/2021-09-10.txt
-rw-r--r--   1 ubuntu hadoop 3042424238 2025-08-29 15:42 /user/ubuntu/data/2021-10-10.txt
-rw-r--r--   1 ubuntu hadoop 3042358698 2025-08-29 15:38 /user/ubuntu/data/2021-11-09.txt
-rw-r--r--   1 ubuntu hadoop 3042923985 2025-08-29 15:40 /user/ubuntu/data/2021-12-09.txt
-rw-r--r--   1 ubuntu hadoop 3042868087 2025-08-29 15:28 /user/ubuntu/data/2022-01-08.txt
-rw-r--r--   1 ubuntu hadoop 3043148790 2025-08-29 15:29 /user/ubuntu/data/2022-02-07.txt
-rw-r--r--   1 ubuntu hadoop 3042312191 2025-08-29 15:42 /user/ubuntu/data/2022-03-09.txt
-rw-r--r--   1 ubuntu hadoop 3041973966 2025-08-29 15:29 /user/ubuntu/data/2022-04-08.txt
-rw-r--r--   1 ubuntu hadoop 3073760161 2025-08-29 15:40 /user/ubuntu/data/2022-05-08.txt
-rw-r--r--   1 ubuntu hadoop 3089378246 2025-08-29 15:38 /user/ubuntu/data/2022-06-07.txt
-rw-r--r--   1 ubuntu hadoop 3089589719 2025-08-29 15:35 /user/ubuntu/data/2022-07-07.txt
-rw-r--r--   1 ubuntu hadoop 3090000257 2025-08-29 15:35 /user/ubuntu/data/2022-08-06.txt
-rw-r--r--   1 ubuntu hadoop 3089390874 2025-08-29 15:33 /user/ubuntu/data/2022-09-05.txt
-rw-r--r--   1 ubuntu hadoop 3109468067 2025-08-29 15:42 /user/ubuntu/data/2022-10-05.txt
-rw-r--r--   1 ubuntu hadoop 3136657969 2025-08-29 15:35 /user/ubuntu/data/2022-11-04.txt
[Fri 29 Aug 2025 03:42:29 PM UTC] ----------------------------------------------------------
[Fri 29 Aug 2025 03:42:29 PM UTC] [INFO] Data was successfully copied to HDFS
ubuntu@rc1a-dataproc-m-am3rujh2f985rur8:~$ hdfs dfs -ls /user/ubuntu/data
Found 40 items
-rw-r--r--   1 ubuntu hadoop 2807409271 2025-08-29 15:32 /user/ubuntu/data/2019-08-22.txt
-rw-r--r--   1 ubuntu hadoop 2854479008 2025-08-29 15:30 /user/ubuntu/data/2019-09-21.txt
-rw-r--r--   1 ubuntu hadoop 2895460543 2025-08-29 15:32 /user/ubuntu/data/2019-10-21.txt
-rw-r--r--   1 ubuntu hadoop 2939120942 2025-08-29 15:32 /user/ubuntu/data/2019-11-20.txt
-rw-r--r--   1 ubuntu hadoop 2995462277 2025-08-29 15:32 /user/ubuntu/data/2019-12-20.txt
-rw-r--r--   1 ubuntu hadoop 2994906767 2025-08-29 15:38 /user/ubuntu/data/2020-01-19.txt
-rw-r--r--   1 ubuntu hadoop 2995431240 2025-08-29 15:42 /user/ubuntu/data/2020-02-18.txt
-rw-r--r--   1 ubuntu hadoop 2995176166 2025-08-29 15:38 /user/ubuntu/data/2020-03-19.txt
-rw-r--r--   1 ubuntu hadoop 2996034632 2025-08-29 15:40 /user/ubuntu/data/2020-04-18.txt
-rw-r--r--   1 ubuntu hadoop 2995666965 2025-08-29 15:33 /user/ubuntu/data/2020-05-18.txt
-rw-r--r--   1 ubuntu hadoop 2994699401 2025-08-29 15:32 /user/ubuntu/data/2020-06-17.txt
-rw-r--r--   1 ubuntu hadoop 2995810010 2025-08-29 15:37 /user/ubuntu/data/2020-07-17.txt
-rw-r--r--   1 ubuntu hadoop 2995995152 2025-08-29 15:28 /user/ubuntu/data/2020-08-16.txt
-rw-r--r--   1 ubuntu hadoop 2995778382 2025-08-29 15:29 /user/ubuntu/data/2020-09-15.txt
-rw-r--r--   1 ubuntu hadoop 2995868596 2025-08-29 15:37 /user/ubuntu/data/2020-10-15.txt
-rw-r--r--   1 ubuntu hadoop 2995467533 2025-08-29 15:35 /user/ubuntu/data/2020-11-14.txt
-rw-r--r--   1 ubuntu hadoop 2994761624 2025-08-29 15:35 /user/ubuntu/data/2020-12-14.txt
-rw-r--r--   1 ubuntu hadoop 2995390576 2025-08-29 15:30 /user/ubuntu/data/2021-01-13.txt
-rw-r--r--   1 ubuntu hadoop 2995780517 2025-08-29 15:42 /user/ubuntu/data/2021-02-12.txt
-rw-r--r--   1 ubuntu hadoop 2995191659 2025-08-29 15:30 /user/ubuntu/data/2021-03-14.txt
-rw-r--r--   1 ubuntu hadoop 2995446495 2025-08-29 15:28 /user/ubuntu/data/2021-04-13.txt
-rw-r--r--   1 ubuntu hadoop 3029170975 2025-08-29 15:35 /user/ubuntu/data/2021-05-13.txt
-rw-r--r--   1 ubuntu hadoop 3042691991 2025-08-29 15:35 /user/ubuntu/data/2021-06-12.txt
-rw-r--r--   1 ubuntu hadoop 3041980335 2025-08-29 15:29 /user/ubuntu/data/2021-07-12.txt
-rw-r--r--   1 ubuntu hadoop 3042662187 2025-08-29 15:42 /user/ubuntu/data/2021-08-11.txt
-rw-r--r--   1 ubuntu hadoop 3042455173 2025-08-29 15:38 /user/ubuntu/data/2021-09-10.txt
-rw-r--r--   1 ubuntu hadoop 3042424238 2025-08-29 15:42 /user/ubuntu/data/2021-10-10.txt
-rw-r--r--   1 ubuntu hadoop 3042358698 2025-08-29 15:38 /user/ubuntu/data/2021-11-09.txt
-rw-r--r--   1 ubuntu hadoop 3042923985 2025-08-29 15:40 /user/ubuntu/data/2021-12-09.txt
-rw-r--r--   1 ubuntu hadoop 3042868087 2025-08-29 15:28 /user/ubuntu/data/2022-01-08.txt
-rw-r--r--   1 ubuntu hadoop 3043148790 2025-08-29 15:29 /user/ubuntu/data/2022-02-07.txt
-rw-r--r--   1 ubuntu hadoop 3042312191 2025-08-29 15:42 /user/ubuntu/data/2022-03-09.txt
-rw-r--r--   1 ubuntu hadoop 3041973966 2025-08-29 15:29 /user/ubuntu/data/2022-04-08.txt
-rw-r--r--   1 ubuntu hadoop 3073760161 2025-08-29 15:40 /user/ubuntu/data/2022-05-08.txt
-rw-r--r--   1 ubuntu hadoop 3089378246 2025-08-29 15:38 /user/ubuntu/data/2022-06-07.txt
-rw-r--r--   1 ubuntu hadoop 3089589719 2025-08-29 15:35 /user/ubuntu/data/2022-07-07.txt
-rw-r--r--   1 ubuntu hadoop 3090000257 2025-08-29 15:35 /user/ubuntu/data/2022-08-06.txt
-rw-r--r--   1 ubuntu hadoop 3089390874 2025-08-29 15:33 /user/ubuntu/data/2022-09-05.txt
-rw-r--r--   1 ubuntu hadoop 3109468067 2025-08-29 15:42 /user/ubuntu/data/2022-10-05.txt
-rw-r--r--   1 ubuntu hadoop 3136657969 2025-08-29 15:35 /user/ubuntu/data/2022-11-04.txt
ubuntu@rc1a-dataproc-m-am3rujh2f985rur8:~$