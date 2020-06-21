#!/bin/bash

# A script to build a Hexo site
REPO_NAME="jeromechan.github.io"
BRANCH_SOURCE="source-hexo"
BRANCH_MASTER="master"
CURRENT_DIR=${PWD}

# 1. 切换至source-hexo分支下，执行hexo clean & hexo generate
git checkout $BRANCH_SOURCE
hexo clean
hexo generate

# 2. 执行git add * & git commit -am 'Auto update file using hexo-deploy.sh script.' & git push
git add *
git commit -am 'Auto update file using hexo-deploy.sh script.'
git push

# 3. 将public文件夹内容拷贝至/tmp/jeromechan.github.io，额外包含项目目录下的"CNAME"文件
#mkdir $REPO_NAME > /dev/null 2>&1
rm -rf /tmp/$REPO_NAME
cp -r ./public/ /tmp/$REPO_NAME
cp ./CNAME /tmp/$REPO_NAME/

# 4. 切换至master分支下，删除所有非隐藏的项目文件，然后执行git commit -am 'Auto reset master files using hexo-deploy.sh script.'
git checkout $BRANCH_MASTER
rm -r $CURRENT_DIR/*
git commit -am 'Auto reset master files using hexo-deploy.sh script.'

# 5. 将/tmp/jeromechan.github.io文件内容全部拷贝至master分支下
cp -r /tmp/$REPO_NAME/* ./
rm -rf /tmp/$REPO_NAME

# 6. 执行git add * & git commit -am 'Refresh and add master files using hexo-deploy.sh script.' & git push
git add *
git commit -am 'Refresh and add master files using hexo-deploy.sh script.'
git push

# 7. 切换至source-hexo分支下
git checkout $BRANCH_SOURCE