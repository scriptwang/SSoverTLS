#!/bin/bash


# 产生随机密码
function getRandomPwd(){
    num=32
    if [ $# == 1 ];then
        num=$1
    fi
    echo "$(date +%s)$(shuf -i 10000-65536 -n 1)" | sha256sum | base64 | head -c $num ; echo
}

# url编码
function urlencode() {
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
    *) printf "$c" | xxd -p -c1 | while read x;do printf "%%%s" "$x";done
  esac
done
}

function get_random_webs(){
    webs=(
    "http://down.cssmoban.com/cssthemes6/sstp_7_Kairos.zip"
    "http://down.cssmoban.com/cssthemes6/foun_8_Sinclair.zip"
    "http://down.cssmoban.com/cssthemes6/tmag_23_Infinity.zip"
    "http://down.cssmoban.com/cssthemes6/dash_1_simple.zip"
    "http://down.cssmoban.com/cssthemes6/inva_2_evolo.zip"
    "http://down.cssmoban.com/cssthemes6/oplv_9_stage.zip"
    "http://down.cssmoban.com/cssthemes6/oplv_2_html5updimension.zip"
    "http://down.cssmoban.com/cssthemes6/bpus_10_showtracker.zip"
    "http://down.cssmoban.com/cssthemes6/sstp_9_Typerite.zip"
    "http://down.cssmoban.com/cssthemes6/resu_1_designer-Portfolio.zip"
    "http://down.cssmoban.com/cssthemes6/wsdp_30_invictus.zip"
    "http://down.cssmoban.com/cssthemes6/zero_57_zMatcha.zip"
    "http://down.cssmoban.com/cssthemes6/zero_54_zHarvest.zip"
    "http://down.cssmoban.com/cssthemes6/zero_38_zPhotoGrap.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1927_dag.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1913_daq.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1893_dem.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1876_czx.zip"
    "http://down.cssmoban.com/cssthemes6/wsdp_20_union.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1873_cyq.zip"
    "http://down.cssmoban.com/cssthemes6/wsdp_11_lambda.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1861_cto.zip"
    "http://down.cssmoban.com/cssthemes6/fish_30_rapoo.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1796_cvc.zip"
    "http://down.cssmoban.com/cssthemes6/zero_21_zCreative.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1807_cti.zip"
    "http://down.cssmoban.com/cssthemes6/mzth_14_unicorn.zip"
    "http://down.cssmoban.com/cssthemes6/crui_1_agnes.zip"
    "http://down.cssmoban.com/cssthemes6/crui_3_ava.zip"
    "http://down.cssmoban.com/cssthemes6/cpts_1845_dcy.zip"
    "http://down.cssmoban.com/cssthemes6/tlip_5_material-app.zip"
    "http://down.cssmoban.com/cssthemes6/tlip_10_wedding.zip"
    "http://down.cssmoban.com/cssthemes6/quar_2_atlantis.zip"
    "http://down.cssmoban.com/cssthemes5/tope_11_steak.zip"
    "http://down.cssmoban.com/cssthemes1/azmind_1_xb.zip"
    "http://down.cssmoban.com/cssthemes4/ft5_67_simple.zip"
    "http://down.cssmoban.com/cssthemes3/dgfp_27_hm.zip"
    "http://down.cssmoban.com/cssthemes/frt_26.zip"
    "http://down.cssmoban.com/cssthemes1/ftmp_135_up.zip"
    "http://down.cssmoban.com/cssthemes6/mdbo_14_Landing-Page.zip"
    "http://down.cssmoban.com/cssthemes6/tmag_23_Infinity.zip"
    "http://down.cssmoban.com/cssthemes6/zero_39_zPinPin.zip"
    "http://down.cssmoban.com/cssthemes3/cpts_137_elv.zip"
    "http://down.cssmoban.com/cssthemes6/zero_50_zAnimal.zip"
    "http://down.cssmoban.com/cssthemes2/dgfp_12_cvh.zip"
    "http://down.cssmoban.com/cssthemes3/sbtp_2_fb.zip"
    "http://down.cssmoban.com/cssthemes3/npts_10_cvl.zip"
    "http://down.cssmoban.com/cssthemes1/ftmp_24.zip"
    "http://down.cssmoban.com/cssthemes4/dstp_28_P2.zip"
    "http://down.cssmoban.com/cssthemes5/tpmo_520_highway.zip"
    "http://down.cssmoban.com/cssthemes5/twts_168_awesplash.zip"
    "http://down.cssmoban.com/cssthemes6/wsdp_7_edge.zip"
    "http://down.cssmoban.com/cssthemes3/mstp_89_rock4life.zip"
    )
    RANDOM=$$$(date +%s)
    rand=$[$RANDOM % ${#webs[@]}]
    echo ${webs[$rand]}
}

# echo $(gen_ss_link_new $ssmethod $sspwd $domain 443 $v2rayPath $(urlencode 中文))
function gen_ss_link_new(){
    enc=$1
    pwd=$2
    host=$3
    port=$4
    path=$5
    mark=$6

    # -n flag used to remove newline
    # -w 0 ==>> --wrap=COLS Wrap encoded lines after COLS character (default 76). Use 0 to disable line wrapping.
    base64encode=$(echo -n "$enc:$pwd" | base64 -w 0)
    pluginStr="plugin=v2ray%3btls%3bhost%3d"$host"%3bpath%3d%2f"$path
    echo "ss://"$base64encode"@"$host":"$port"/?"$pluginStr"#"$mark
}

# 获取ip
function getIp(){
    name=""
    if [ $# -ne 0 ];then
        name=$1
    fi
    # install ifconfig
    hash ifconfig 2>/dev/null || {
        yum -y install net-tools 2 > /dev/null
    }
    r=`ifconfig $name | grep "inet.*broadcast.*" | cut -d' ' -f10`
    echo $r
}

# 从域名获取IP
function get_ip_from_domain(){
    ADDR=$1
    IP=`ping ${ADDR} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    echo ${IP}
}

# 安装相应工具软件
function install_tools(){
    hash docker 2>/dev/null || {
        # 安装docker
        wget -qO- https://get.docker.com/ | bash
    }
    # 启动并且自启
    systemctl restart docker && systemctl enable docker
    # install zip
    hash zip 2>/dev/null || {
        yum -y install zip
    }
    # install unzip
    hash unzip 2>/dev/null || {
        yum -y install unzip
    }
    # install wget if not exists
    hash wget 2>/dev/null || {
        yum -y install wget
    }
    # install ifconfig
    hash ifconfig 2>/dev/null || {
        yum -y install net-tools
    }
}



# 修改时间为东八区
function check_datetime(){
    # 覆盖系统时间
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # 更新系统硬件时间
    hwclock
}

# 添加路径
function add_path(){
    path=$1
    name=$2
    # 添加链接
    curl https://$domain/$v2rayPath/add?$path 2>/dev/null
    # 生成分享链接
    echo "当前分享链接为:"
    echo ''
    export share=$(gen_ss_link_new $ssmethod $sspwd $domain 443 $path $(urlencode $name))
    echo $share
    echo ''
}


function add_mynet(){
    # 先清除所有使用该网络的容器才能删除该网络
    docker stop ngx 2>/dev/null
    docker rm ngx 2>/dev/null
    docker stop ss 2>/dev/null
    docker rm ss 2>/dev/null
    docker network rm mynet 2>/dev/null
    # 创建网络
    docker network create --subnet=172.18.0.0/16 mynet
}


function add_ngx(){
    # 清理一些资源，避免重复创建出现问题
    rm -rf /etc/letsencrypt
    rm -rf /etc/ngx
    rm -rf /usr/share/nginx
    docker stop ngx 2>/dev/null
    docker rm ngx 2>/dev/null
    # 创建ngx容器
    docker run --name ngx \
    --network mynet --ip ${nginxip} \
    --restart=always \
    -e v2rayPath=$v2rayPath \
    -e domain=$domain \
    -e ssipport=${ssip}:${ssport} \
    -p 80:80 -p 443:443 \
    -v /etc/letsencrypt:/etc/letsencrypt \
    -v /etc/ngx:/etc/ngx \
    -v /etc/localtime:/etc/localtime \
    -v /usr/share/nginx/html:/usr/share/nginx/html \
    -d kimoqi/nginx4ss 2>/dev/null
}

function domain_register(){
    # 域名认证
    # 自动输入A 1 2 -->> A为同意  1为选择第一个域名 2开启80端口跳转
    docker exec -it ngx /bin/sh -c '{ echo "A"; echo "1"; echo "2"; } | /usr/bin/certbot --nginx --register-unsafely-without-email'
}

function add_website(){
    # 设置站点模板
    path=/usr/share/nginx/html/
    # 删除原来的文件
    rm -rf ${path}*
    # 取出文件名
    filename=$(basename $website .zip)
    # 下载解压
    wget $website -O $path/tmp.zip && unzip $path/tmp.zip -d $path
    # 拷贝文件到外面
    cp -r $path/$filename/* $path
}

function add_ss(){
    # 清理一些资源，避免重复创建出现问题
    docker stop ss 2>/dev/null
    docker rm ss 2>/dev/null
    # 设置带有v2ray插件的shadowsocks
    docker run -d \
    --network mynet --ip ${ssip} \
    --name ss \
    --restart=always \
    -e "ARGS=--plugin v2ray-plugin --plugin-opts server;path=/$v2rayPath;loglevel=none" \
    -e PASSWORD=$sspwd \
    -e SERVER_PORT=$ssport \
    -e METHOD=$ssmethod \
    -v /etc/localtime:/etc/localtime \
    acrisliu/shadowsocks-libev 2>/dev/null
}


function define_var(){
    export nginxip=172.18.0.2
    export ssip=172.18.0.3
    export ssport=8388
}


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


function input_v2rayPath(){
    read -p "请输入v2ray路径(输入为空则随机生成)：" inputpath
    if [[ "$inputpath" == "" ]];then
        inputpath=$(getRandomPwd 8)
    fi
    export v2rayPath=$inputpath
    echo '设置v2ray路径为 '${v2rayPath}
}


function input_sspwd(){
    read -p "请输入shadowsocks密码(输入为空则随机生成)：" inputsspwd
    if [[ "$inputsspwd" == "" ]];then
        inputsspwd=$(getRandomPwd 10)
    fi
    export sspwd=$inputsspwd
    echo '设置shadowsocks密码为 '${sspwd}
}


function input_ssmethod(){
    read -p "请输入shadowsocks加密方式：" inputssmethod
    if [[ "$inputssmethod" == "" ]];then
        echo 'shadowsocks加密方式不能为空！脚本退出！'
    fi
    export ssmethod=$inputssmethod
    echo '设置shadowsocks加密方式为 '${ssmethod}
}


function init_website(){
    read -p "请输入站点模板路径(只支持后缀名为.zip的文件)，为空将随机选择站点模板(注意:不知道怎么输入直接回车即可!)：" inputweb
    if [[ "$inputweb" == "" ]];then
        inputweb=$(get_random_webs)
    fi
    # 定义站点模板
    export website=$inputweb
    echo '设置站点模板为 '${website}
}



# 更新.bashrc
function update_bashrc(){
    cat >> ~/.bashrc<<EOF
export domain=${domain}
export v2rayPath=${v2rayPath}
export sspwd=${sspwd}
export ssmethod=${ssmethod}
export website=${website}
export share=${share}


EOF
. ~/.bashrc
}



function print_help(){
    echo '帮助信息:'
    echo ' -h 打印本信息'
    echo ' -i 安装'
    echo ' -w 更新伪装站点'
    echo "默认分享链接:"${share}
}


function install(){
    input_domain
    input_v2rayPath
    input_sspwd
    input_ssmethod
    init_website
    define_var
    echo "安装所需工具中 docker/zip/unzip/wget/ifconfig..."
    install_tools 2>/dev/null

    echo "调整时间为东八区中..."
    check_datetime 2>/dev/null

    echo "添加网络中..."
    add_mynet 2>/dev/null

    echo "添加Nginx容器中..."
    add_ngx 2>/dev/null

    echo "认证域名开始..."
    sleep 2
    domain_register
    echo "认证域名成功..."

    echo "添加站点模板中..."
    add_website 2>/dev/null
    echo "添加站点模板成功!"

    echo "添加shadowsocks容器中..."
    add_ss

    print_help

    echo "添加分享链接中..."
    add_path $domain 默认路径

    update_bashrc
}


function update_website(){
    init_website
    add_website 2>/dev/null
    echo '设置完毕！'
}


# 调用入口
if [[ "$1" == "-h" ]];then
    # 帮助
    print_help
elif [[ "$1" == "-i" ]];then
    # 安装
    install
elif [[ "$1" == "-w" ]];then
    # 更新伪站
    update_website
else
    echo "没有这个选项${1}"
fi
