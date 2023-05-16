from scapy.all import *
import numpy as np
import netifaces
import pandas as pd
global_lock = threading.Lock()
#############################################################################
#	SNIFFER DE REDE PARA EXTRACAO DE CARACTERISTICAS ONLINE         	    #
#			COM BASE EM ARQUIVO PCAP                                        #
#																			#		
#	AUTOR: BRUNO HENRIQUE SCHWENGBER										#						
#	DATA:  09/2020											     			#
#############################################################################

class Sniffer():
	cont=0
	pkts = []
	
	thr_cont=0
	total = pd.DataFrame()
	#Funcao responsavel por capturar os pacotes e calcular a taxa de pacotes. A maior taxa é definida como bot
	def pkt_handler(self,pkt): 
		self.cont += 1 #contador e acrescentado em 1 para contagem do tamanho da janela
		self.pkts.append(pkt[IP].src)
		
		#print(self.cont)
		
		if self.cont % 10 == 0:
			self.thr_cont += 1

			#print("{} packets".format(self.cont))			
			#print("{} rodadas de treino e teste".format(self.thr_count))
			
			
			grouped_df = pd.DataFrame(data=self.pkts, columns=['IP']).groupby(['IP'])
			samples = []
			for index,amostra in grouped_df:
				samples.append(
					pd.DataFrame(data={
						"%": [amostra['IP'].size/self.cont]
						}, index=[str(amostra['IP'].values[0])],
						))
			total=pd.concat(samples)
			
		if self.cont % 10 == 0:
			f = open("resultado.txt", "a")
			txt="O IP {} É SUSPEITO REPRESENTANDO {} % DO TRÁFEGO \n".format(total.idxmax().values[0], total['%'][total.idxmax()].values[0]*100)
			f.write(txt)
			f.close()
			print(txt)
			
			
            	

#Inicia o Codigo chamando a funcao principal.
if __name__ == '__main__': 
	snif = Sniffer()
	#Thread(target = sniff, kwargs={'iface':'wlp0s20f3', 'prn':partial(snif.pkt_handler, 'from-server'), 'filter':"tcp", 'store':0}).start()
	print("entrando")
	sniff(iface='from-server', prn=snif.pkt_handler, filter="tcp", store=0)		
