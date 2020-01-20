#!/bin/bash


# 检查环境
function check_env(){
    hash docker 2>/dev/null || {
        echo "没有安装docker，退出！"
        exit 0
    }

    [ ! "$(docker ps  | grep ngx)" ] && {
	    echo 'nginx容器不存在或已经停止运行，退出'
	    exit 0
    }

    [ ! "$(docker ps  | grep ss)" ] && {
	    echo 'ss容器不存在或已经停止运行，退出'
	    exit 0
    }

}

# 从域名获取IP
function get_ip_from_domain(){
    ADDR=$1
    IP=`ping ${ADDR} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    echo ${IP}
}


# 输入域名
function input_domain(){
    read -p "请输入域名：" inputdomain
    # 检查域名
    localip=$(getIp eth0)
    domainip=$(get_ip_from_domain ${inputdomain})
    if [[ "$localip" != "$domainip" ]];then
        echo "该域名 ${inputdomain}指向IP为 ${domainip}，非本机IP ${localip}，请在域名控制台将域名指向本机IP，脚本退出，再见！"
        exit 0
    fi
    # 定义域名
    export domain=$inputdomain
    echo '设置域名为 '${domain}
}

# 输入v2ray path
function input_v2rayPath(){
    read -p "请输入v2ray根路径(即安装脚本所用的路径，不知道就执行cat ~/.bashrc 找到v2rayPath字段的值)：" inputpath
    if [[ "$inputpath" == "" ]];then
        echo "v2ray根路径不能为空，退出！"
        exit 0
    fi
    export v2rayPath=$inputpath
    echo '设置v2ray根路径为 '${v2rayPath}
}

# 获取ss容器的ip
function get_ss_ip(){
    export ssip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  ss`
}

# 生成配置文件
function gen_domain_conf(){
    echo "生成配置文件"$(pwd)/$domain.conf
    get_ss_ip
    cat > $(pwd)/$domain.conf<<EOF
server {
    listen       80;
    server_name  $domain;
    access_log  /etc/ngx/$domain.log  main;
    location / {
        include /etc/ngx/conf.d/*.path;  # 需要添加原来服务器下的路径信息
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    location /$v2rayPath {
        proxy_redirect off;
        proxy_pass http://$ssip:8388;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    #add path script 添加路径脚本
    location /$v2rayPath/add {
        fastcgi_param       SCRIPT_FILENAME     "/etc/ngx/add";
        fastcgi_param       PATH_INFO           \$uri;
        fastcgi_param       QUERY_STRING        \$args;
        fastcgi_param       HTTP_HOST           \$server_name;
        fastcgi_pass        unix:/var/run/fcgiwrap.socket;
        include             fastcgi_params;
    }
    #del path script 删除路径脚本
    location /$v2rayPath/del {
        fastcgi_param       SCRIPT_FILENAME     "/etc/ngx/del";
        fastcgi_param       PATH_INFO           \$uri;
        fastcgi_param       QUERY_STRING        \$args;
        fastcgi_param       HTTP_HOST           \$server_name;
        fastcgi_pass        unix:/var/run/fcgiwrap.socket;
        include             fastcgi_params;
    }
    #statistic traffic script 流量统计脚本
    location /$v2rayPath/statis {
        fastcgi_param       SCRIPT_FILENAME     "/etc/ngx/statis";
        fastcgi_param       PATH_INFO           \$uri;
        fastcgi_param       QUERY_STRING        \$args;
        fastcgi_param       HTTP_HOST           \$server_name;
        fastcgi_pass        unix:/var/run/fcgiwrap.socket;
        include             fastcgi_params;
    }
}
EOF
    docker cp $(pwd)/$domain.conf  ngx:/etc/nginx/conf.d/$domain.conf
    docker exec -it ngx nginx -s reload
}


# 域名HTTPS证书注册
function domain_register(){
    # 域名认证
    # 自动输入A 1 2 -->> A为同意  1为选择第一个域名 2开启80端口跳转
    # docker exec -it ngx /bin/sh -c '{ echo "A"; echo "1"; echo "2"; } | /usr/bin/certbot --nginx --register-unsafely-without-email'
    docker exec -it ngx certbot --nginx --register-unsafely-without-email
}



function main(){
    # 检查环境
    check_env
    # 输入域名
    input_domain
    # 输入v2ray path
    input_v2rayPath
    # 生成配置文件
    gen_domain_conf
    # 注册域名（需要手动选择自己要注册的域名）
    domain_register
}

main