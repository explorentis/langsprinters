#!/usr/bin/php
<?php
// rewrited from compiled/python/normal.py

function calc_count_cipher($number) {
    $result = 1;
    while ($number > 9) {
        $number = floor($number / 10);
        $result += 1;
    }
    return $result;
}
#
function check_ppdi($number) {
    $power = calc_count_cipher($number);
    $current_cipher = 0;
    $cipher = 0;
    $div = 1;
    $narciss = 0;
    while ($current_cipher != $power) {
        $cipher = floor($number / $div) % 10;
        $div = $div * 10;
        $narciss += pow($cipher, $power);
        $current_cipher += 1;
    }
    return $narciss == $number;
}

$max_number = 10000000;

if (count($argv) > 1) {
    $max_number = (int)$argv[1];
}
$number = 1;
while ($number != $max_number) {
    if (check_ppdi($number)) {
        echo "$number is Armstrong number\n";
    }
    $number += 1;
}
