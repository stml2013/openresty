#!/bin/bash

#
# - Filename: nginx.sh
# - Description: 
#       nginx服务器控制脚本
# - Version: 0.0.1
# - Author: 
#

prefix="$PWD"; #根据具体环境修改
ngx_conf="${prefix}/conf/nginx.conf";
ngx_1_4="/usr/local/openresty-1.4.2.8/nginx/sbin/nginx";
ngx_1_7="/usr/local/openresty-1.7.10.2/nginx/sbin/nginx";
ngx_1_974="/usr/local/openresty-1.9.7.4/nginx/sbin/nginx";
ngx_1_975="/usr/local/openresty-1.9.7.5/nginx/sbin/nginx";
ngx_old="/usr/local/openresty/nginx/sbin/nginx";
#ngx="$ngx_1_975";
ngx="/home/smtl2013/local/openresty_1975/nginx/sbin/nginx";

if [[ ! -d "$prefix" ]]; then
    echo "TODO";
    exit 1;
fi

cd $prefix

function func_start()
{
    ${ngx} -p ${prefix} -c ${ngx_conf};
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi
}

function func_stop()
{
    ps -ef |grep -v grep|grep "nginx:" &> /dev/null;
    if [[ $? -ne 0 ]]; then
        return 0;
    fi
    ${ngx} -p ${prefix} -c ${ngx_conf} -s stop;
    if [[ $? -ne 0 ]]; then
        # exit 1
        return 1
    fi
}

function func_status()
{
    pid=$(cat $prefix/logs/nginx.pid)
    ps -ef |grep -v grep|grep -w "$pid";
    if [[ $? -ne 0 ]]; then
        return 0;
    fi
    sudo netstat -nltp |grep -w "$pid";
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi
}

function func_reload()
{
    ${ngx} -p ${prefix} -c ${ngx_conf} -s reload;
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi
}

function func_reopen()
{
    ${ngx} -p ${prefix} -c ${ngx_conf} -s reopen;
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi
}

function func_test()
{
    ${ngx} -p ${prefix} -c ${ngx_conf} -t;
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi
}

function func_clean()
{
    rm -f ${prefix}/logs/error.log ${prefix}/logs/access.log ${prefix}/logs/*log* ${prefix}/logs/idx_*;
}

function func_comment_debug()
{
    find . -name "*.lua" |xargs sed -i 's/\([^-]\)ngx.log(ngx.DEBUG/\1--ngx.log(ngx.DEBUG/g'
}

function func_uncomment_debug()
{
    find . -name "*.lua" |xargs sed -i 's/--ngx.log(ngx.DEBUG/ngx.log(ngx.DEBUG/g'
}

case "$1" in 
start)
    func_start;
    ;;
stop)
    func_stop;
    ;;
status)
    func_status;
    ;;
restart)
    func_stop;
    sleep 3;
    func_start;
    ;;
reload)
    func_reload;
    ;;
reopen)
    func_reopen;
    ;;
test)
    func_test;
    ;;
clean)
    func_clean;
    ;;
debug)
    func_stop; func_clean; func_start;tail -f logs/error.log;
    ;;
run)
    func_stop; func_clean; func_start;
    ;;
cd|comment_debug)
    func_comment_debug;
    ;;
uncd|uncomment_debug)
    func_uncomment_debug;
    ;;
help)
    echo "Usage: $0 {start | stop | reopen | reload | help | clean | cd | uncd}"
    exit 0;
    ;;
*)
    echo "Usage: $0 {start | stop | reopen | reload | help | clean | cd | uncd}}"
    exit 1;
    ;;
esac

cd - > /dev/null
