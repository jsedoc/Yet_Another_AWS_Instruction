export YOUR_RESEARCH_S3_BUCKET=
export YOUR_SECURITY_CREDS=

echo "mounting EFS"
sudo yum install -y nfs-utils
sudo mkdir /data
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-2f0c5666.efs.us-east-1.amazonaws.com:/ /data

echo "mounting local EFS volumes"
sudo mkdir -p /code_dir
sudo mount /dev/xvdf /code_dir
sudo chmod a+rwx /code_dir
sudo mkdir -p /checkpoints
sudo mount /dev/xvdg /checkpoints
sudo chmod a+rwx /checkpoints

echo "mounting S3 bucket"
sudo yum update all
sudo yum -y install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure --prefix=/usr --with-openssl
make
sudo make install
which s3fs
sudo echo $YOUR_SECURITY_CREDS > /etc/passwd-s3fs
sudo chmod 640 /etc/passwd-s3fs
mkdir /s3_research_data
s3fs $YOUR_RESEARCH_S3_BUCKET -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 /s3_research_data
df -Th /s3_research_data

echo "DONE!!"
