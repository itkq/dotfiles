function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -dc $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

function intra-ip() {
  ipconfig getifaddr $(route get default|grep 'interface:'|awk '{print $2}')
}

function wifi() {
  if [ $# -ne 1 ]; then
    echo 'usage: wifi (on|off|reboot)'
    return 1
  fi

  case $1 in
    on) networksetup -setairportpower en0 on ;;
    off) networksetup -setairportpower en0 off ;;
    reboot) networksetup -setairportpower en0 off && networksetup -setairportpower en0 on ;;
  esac
}

function get-ssl-cert() {
  if [ $# -ne 1 ]; then
    echo 'usage: get-ssl-cert domain'
    return 1
  fi

  local domain=$1
  openssl s_client -connect $domain:443 -servername $domain -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text
}
