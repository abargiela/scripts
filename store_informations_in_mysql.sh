#!/bin/bash


#Database configurations
USER="usr_sups"
DB="db_sups"
HOST="192.168.122.5"
PASS="a1b2c3d4"


function sups_install() {


echo "To install:


- Access your mysql.
mysql -u root -p -A -h YOUR_HOST


- So, run:
CREATE DATABASE db_sups;
use db_sups;
GRANT SELECT, INSERT, DELETE, UPDATE ON db_sups.* TO usr_sups@'%' IDENTIFIED BY 'DENIFEhereYOURpassword';
CREATE TABLE products_list ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, product_name VARCHAR(100), product_id VARCHAR(100), product_status VARCHAR(30), cur_timestamp TIMESTAMP(8) );
FLUSH PRIVILEGES;


- Now in the script set PASS variable at line 7"
}


function db_add() {
echo "To add you need inform:
Product Name:"
read PRODUCT_NAME;
echo "Product ID"
read PRODUCT_ID;
echo "Product status, OK or NOK"
read PRODUCT_STATUS;
mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups -e "INSERT INTO products_list (id, product_name,product_id, product_status, cur_timestamp) VALUES (id,'${PRODUCT_NAME}','${PRODUCT_ID}','${PRODUCT_STATUS}',cur_timestamp);";
}


function db_status() {
mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups  -e "select id,product_id,product_name,product_status from products_list"
}


function db_changeStatus() {
mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups  -e "select id,product_id,product_name,product_status from products_list"
echo "Choose above the id that you want to change:"
read ID;
echo "Type the new value to product_id"
read PRODUCT_NAME;
echo "Product ID"
read PRODUCT_ID;
echo "Type the new value to product_status, OK or NOK"
read PRODUCT_STATUS;


mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups -e "UPDATE products_list set product_name='${PRODUCT_ID}', product_id='${PRODUCT_NAME}',  product_status='${PRODUCT_STATUS}' WHERE id=${ID};"
}


function db_remove() {
mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups  -e "select id,product_id,product_name,product_status from products_list"
echo "Choose above the id that you want to remove:"
read ID;
mysql -u ${USER} -p${PASS} -h ${HOST} --database=db_sups -e "DELETE FROM products_list WHERE id=${ID};"
}


case $1 in
-l|list)
 db_status
 ;;
-a|add)
        db_add
        ;;
-r|remove)
        db_remove
        ;;
-c|change)
 db_changeStatus
 ;;
-i|install)
        sups_install
        ;;
-h|-help|--help|help|*)
        echo "  
                -l|list         List all sups.
                -a|add          Add news sups.
                -r|remove       Remove sups.
                -c|change Change status of the product
                -i|install      Install application.
                Usage: ./sups.sh list|add|remove|change|install|-l|-a|-r|-c|-i"   
        ;;
esac
