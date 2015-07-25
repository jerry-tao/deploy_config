set -e
help_info(){
  echo `basename $0: `
  echo 'Need an app name.'
  exit 1
}

if [ $# -lt 1 ] 
then
  help_info
fi

install_requirements


#Add an deploy user
#Just set the web_app home to your user home and add an user for deploy it.
echo "Add an deploy user..."
groupadd webapp
useradd -m -g webapp $1.com
usermod -a -G sudo $1.com
#Install the requirements
install_requirments(){
  echo "Installing the requirements..."
  apt-get install -y wget vim build-essential openssl libreadline6 libreadline6-dev libsqlite3-dev libmysqlclient-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev language-pack-zh-hans libevent-dev postgresql-9.3 libpq-dev postgresql-contrib nginx >> /dev/null
}
#Install rvm/rbenv
echo "Installing the rvm/rbenv..."
#gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
#curl -sSL https://get.rvm.io | sudo bash -s stable

su - $1.com -c 'git clone https://github.com/sstephenson/rbenv.git ~/.rbenv'
su - $1.com -c "echo 'export PATH=\$HOME/.rbenv/bin:\$PATH' >> ~/.bash_profile"
su - $1.com -c "echo 'eval \"\$(rbenv init -)\"' >> ~/.bash_profile"
su - $1.com -c 'git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build'


#Config rvm/rbenv
echo "Config the rvm/rbenv..."
# usermod -a -G rvm $current_user
# rvmsudo rvm requirements
# rvmsudo rvm install 2.1
# rvm use 2.1 --default
su - $1.com -c 'rbenv install 2.1.5'
su - $1.com -c 'rbenv global 2.1.5'

#Install nodejs

echo "Installing the nodejs..."
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs >> /dev/null

#Install passenger(If you like)

# echo "Installing the passenger..."
# gem install passenger
# rvmsudo passenger-install-nginx-module

#Install the postgresql


echo "Setting the postgresql..."
su - postgres -c "psql  -c \"ALTER USER postgres WITH PASSWORD 'postgres';\""
su - postgres -c "psql  -c 'create database $1_dev';"
su - postgres -c "psql  -c 'create database $1_test';"
su - postgres -c "psql  -c 'create database $1_production';"

su - $1.com -c 'gem install unicorn'
su - $1.com -c 'gem install bundle'

echo "Config the nginx&unicorn&mina..."

#See the demo file.
#By default there are below files.
git clone https://github.com/jerry-tao/deploy_config
cat deploy_config/nginx.conf | sed "s#YOUR_APP_HOME#/home/$1.com#g" > /etc/nginx/nginx.conf
cat deploy_config/site-enabled.default | sed "s#YOUR_APP_HOME#/home/$1.com#g" > /etc/nginx/sites-enabled/default
rm -rf deploy_config
##{YOUR_APP}/config/deploy.rb
##{YOUR_APP}/config/unicorn.rb
#/etc/nginx/nginx.conf
#/etc/nginx/sites-enabled/defaut
