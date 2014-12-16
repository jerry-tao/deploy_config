```
echo "Add an deploy user..."
groupadd webapp
useradd -m -g webapp xxxx.com
```

```
echo "Installing the requirements..."
sudo apt-get install -y wget vim build-essential openssl libreadline6 libreadline6-dev libsqlite3-dev libmysqlclient-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev language-pack-zh-hans libevent-dev
```

```
echo "Installing the rvm/rbenv..."
#gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
#curl -sSL https://get.rvm.io | sudo bash -s stable
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```

```
echo "Config the rvm/rbenv..."
# usermod -a -G rvm $current_user
# rvmsudo rvm requirements
# rvmsudo rvm install 2.1
# rvm use 2.1 --default
rbenv install 2.1.5
rbenv global 2.1.5
```

```
echo "Installing the nodejs..."
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs
```
```
# echo "Installing the passenger..."
# gem install passenger
# rvmsudo passenger-install-nginx-module
```

```
echo "Installing the postgresql..."
apt-get install postgresql-9.3 libpq-dev postgresql-contrib
echo "Setting the postgresql..."
ALTER USER postgres WITH PASSWORD 'postgres';
create database "testdb";
```

```
echo "Install the nginx&unicorn..."
sudo apt-get install nginx
gem install unicorn
```

```
echo "Config the nginx&unicorn&mina..."
#See the demo file.
