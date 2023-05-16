import time
import csv
import multiprocessing as MP
from datetime import datetime
import os

sem = MP.Semaphore(4)

def write_csv(data):
    sem.acquire()

    with open('bandwidth.csv', 'a') as outfile:
        writer = csv.writer(outfile)
        writer.writerow(data)
    sem.release()


def get_bytes(t, iface='lo'):
    with open('/sys/class/net/' + iface + '/statistics/' + t + '_bytes', 'r') as f:
        data = f.read();
        return int(data)



#get tshark commands to be executed
c = 1
total =0
total_mean = 0
write_csv(["up","down"])
while(True):
    c+=1

    tx1 = get_bytes('tx')
    rx1 = get_bytes('rx')

    time.sleep(0.5)

    tx2 = get_bytes('tx')
    rx2 = get_bytes('rx')

    tx_speed = round((tx2 - tx1)/1000000.0, 4)
    rx_speed = round((rx2 - rx1)/1000000.0, 4)
    
    total += tx_speed+rx_speed 
    total_mean = (total_mean + total)/c

    task = MP.Process(target = write_csv, args = ([datetime.now().strftime("%H:%M:%S.%f"),tx_speed+rx_speed],,))
    task.start()

    print("{} - TX: {}Mbps  RX: {} Mbps".format(datetime.now().strftime("%H:%M:%S.%f"), tx_speed, rx_speed))
    print("\n Total = {} Total Men {}".format(total, total_mean))