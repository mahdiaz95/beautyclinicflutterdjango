from storages.backends.s3boto3 import S3Boto3Storage
from boto3.s3.transfer import TransferConfig

class MinioStorage(S3Boto3Storage):
    def __init__(self, *args, **kwargs):
        kwargs['custom_domain'] = False  
        super().__init__(*args, **kwargs)
        self.transfer_config = TransferConfig(
            multipart_threshold=10 * 1024 * 1024,  
            max_concurrency=5,
            multipart_chunksize=5 * 1024 * 1024, 
            use_threads=True
        )
