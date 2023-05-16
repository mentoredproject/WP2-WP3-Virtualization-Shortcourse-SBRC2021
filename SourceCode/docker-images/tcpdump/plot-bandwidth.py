
#!/usr/bin/python

import pandas as pd
import os
import sys
import matplotlib.pyplot as plt


#os.system('mkdir graficos')

PCAPFILES = ['./resultados/' ]

def getPCapFileNames():
    
    lines = PCAPFILES
    
    pcapfilenames = []
    for eachline in lines:
        if eachline.endswith('.pcap'):
            if os.path.exists(eachline):
                pcapfilenames.append(eachline)
            else:
                print(eachline + ' does not exist')
                exit()
        else:
            if os.path.isdir(eachline):
                for eachfile in os.listdir(eachline):
                    if eachfile.endswith('.pcap'):
                        pcapfilenames.append(eachline.rstrip('/') + '/' + eachfile)
            else:
                print(eachline + ' is not a directory')
                exit()
    return pcapfilenames


unidades = ['Tempo (s)', 'Megabits/s']
inputfiles = getPCapFileNames()

tasks = []
for path in inputfiles:
    filename = path.split('/')[-1]
    print(filename)
    command = ['tshark -nr {} -q -z io,stat,1,BYTES | grep -P '.format(path), '"\d+\s+<>\s+\d+\s*\|\s+\d+"  |', "awk -F '[ |]+'", '{print $2","($5*8/1000000)}']

    
    os.system(command[0]+command[1]+command[2]+" '"+command[3]+"' "+"> ./resultados/bandwidth_{}.csv".format(filename))


    all_devices_samples = pd.read_csv('./resultados/bandwidth_{}.csv'.format(filename), names=unidades)

    all_devices_samples.plot(kind='line',x=unidades[0],y=unidades[1])
    
    plt.savefig('resultados/bandwidth_{}.png'.format(filename))
    