#!/bin/bash

echo "输入节点 ID，以空格隔开："
read -ra inputs

for input in "${inputs[@]}";do

    # 节点名
    echo "Node Name: $input"

    # 内存总量
    mem_capacity=$(sudo /apps/bin/kubectl describe node $input | grep "memory:" | awk 'NR==1 {print $2}')
    mem_capacity=${mem_capacity/Ki/}
    # echo "Memory Capacity: $mem_capacity"

    # 内存使用量
    mem_usage=$(sudo /apps/bin/kubectl describe node $input | grep "memory " | awk 'NR==2 {print $2}')
    mem_usage=${mem_usage/Ki/}
    # echo "Memory Usage: $mem_usage"

    # 内存剩余量
    mem_remaining=$(echo "$mem_capacity - $mem_usage" | bc)
    unit="Ki"
    echo "Memory Remaining: $mem_remaining$unit"

    # CPU 总量
    cpu_capacity=$(sudo /apps/bin/kubectl describe node $input | grep "cpu:" | awk 'NR==1 {print $2}')
    cpu_capacity=$((cpu_capacity * 1000))
    # echo "CPU Capacity: $cpu_capacity"

    # CPU 使用量
    cpu_usage=$(sudo /apps/bin/kubectl describe node $input | grep "cpu" | awk 'NR==3 {print $2}')
    cpu_usage=${cpu_usage:0:-1}
    # echo "CPU Usage: $cpu_usage"

    # CPU 剩余量
    cpu_remaining=$(echo "$cpu_capacity - $cpu_usage" | bc)
    unit="m"
    echo "CPU Remaining: $cpu_remaining$unit"
done