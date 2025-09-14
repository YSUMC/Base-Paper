function serviceprovider() {

    if ("%ip2region_serviceProvider%" == "电信") {
        return "<#3473f4>&l中国电信&r%img_telecom-corp%"
    }
    if ("%ip2region_serviceProvider%" == "移动") {
        return "<#0085cf>&l中国移动</#8ec221>&r%img_mobile-communications%"
    }
    if ("%ip2region_serviceProvider%" == "联通") {
        return "<#e60027>&l中国联通&r%img_united-network-communication%"
    }
    if ("%ip2region_serviceProvider%" == "内网IP") {
        return "<#3473f4>&l中国电信&r%img_telecom-corp%"
    }
}

serviceprovider()