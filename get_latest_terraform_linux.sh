#!/bin/bash
#
# Script that automatically downloads and "installs" the latest terraform version on a linux box
# Set in your crontab for daily/weekly whatever and you'll always have the latest TF with no effort.
# James Permenter
# Sept 12 2023

get_release_version()
{
    
    LINE_NUMBER=70
    CURRENT_LINE=1
    wget https://releases.hashicorp.com/terraform/
    while read -r LINE; do
        if [ $CURRENT_LINE -eq $LINE_NUMBER ]; then
		 VERSION=$(echo $LINE | grep -Eo '[0-9]+\.[0-9]+\.[0-9]' | head -1)
            break
        fi
    CURRENT_LINE=$((CURRENT_LINE + 1))
    done < index.html
    echo "version from index.html is $VERSION"
}

download_terraform()
{
    	
    DL_URL=$(printf 'https://releases.hashicorp.com/terraform/%s/terraform_%s_linux_amd64.zip\n' "$VERSION" "$VERSION")
    wget $DL_URL   
}

install_terraform()
{
    unzip *.zip
    mv terraform /usr/local/bin/tf_${VERSION}
}

cleanup()
{
    rm -f /tmp/index*
    rm -f /tmp/terraform*
}

main()
{
   cd /tmp	
   get_release_version
   download_terraform
   install_terraform
   cleanup
}

main
