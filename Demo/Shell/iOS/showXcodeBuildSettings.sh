#!/usr/bin/env bash

echo -n "\e [31m 确保是在工程当前目录！！！\e [0m"
echo -n "输入当前工程名  > "

read project_name

xcodebuild -project "${project_name}.xcodeproj" -target ${project_name} -configuration Debug -showBuildSettings > "${project_name}.buildSettings.txt"