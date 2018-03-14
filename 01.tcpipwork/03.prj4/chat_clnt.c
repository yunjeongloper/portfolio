#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> 
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>
#include <netinet/in.h>
	
#define BUF_SIZE 100
#define NAME_SIZE 100
	
void * send_msg(void * arg);
void * recv_msg(void * arg);
void error_handling(char * msg);
	
char name[NAME_SIZE]="[DEFAULT]";
char msg[BUF_SIZE];
pthread_mutex_t mutx;
	
int main(int argc, char *argv[])
{
	int sock;
	struct sockaddr_in serv_addr;
	pthread_t snd_thread, rcv_thread;
	void * thread_return;
	if(argc!=4) {
		printf("Usage : %s <IP> <port> <name>\n", argv[0]);
		exit(1);
	 }
	
	sprintf(name, "[%s]", argv[3]);
	sock=socket(PF_INET, SOCK_STREAM, 0);
	
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_addr.s_addr=inet_addr(argv[1]);
	serv_addr.sin_port=htons(atoi(argv[2]));
	  
	if(connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr))==-1)
		error_handling("connect() error");
	
	pthread_create(&snd_thread, NULL, send_msg, (void*)&sock);
	pthread_create(&rcv_thread, NULL, recv_msg, (void*)&sock);
	pthread_join(snd_thread, &thread_return);
	pthread_join(rcv_thread, &thread_return);
	close(sock);  
	return 0;
}

/*�����κ��� ���� �޼��� ���*/
void * recv_msg(void * arg)
{
	int sock = *((int*)arg);
	char name_msg[NAME_SIZE + BUF_SIZE];
	int str_len, i;
	int clnt_num = 0;
	
	while (1)
	{
		str_len = read(sock, name_msg, sizeof(name_msg));
		if (str_len == -1)
			return (void*)-1;
		name_msg[str_len] = 0;
		printf("%s", name_msg);
		printf("\n");

	}
	return NULL;
}

/*�������� �޼��� ����*/
void * send_msg(void * arg)
{
	int sock=*((int*)arg);
	char name_msg[NAME_SIZE + BUF_SIZE];
	int str_len = 0;
	char clnt_close[100];

	printf("%s��, ȯ���մϴ�!\nä�� ���Ḧ ���Ͻø� Q/q�� �Է����ּ���:)", name);
	sprintf(name_msg, "%s", name);
	write(sock, name_msg, strlen(name_msg));

	while(1) 
	{
		printf("\n%s", name);
		fgets(msg, BUF_SIZE, stdin);
		if(!strcmp(msg,"q\n")||!strcmp(msg,"Q\n")) 
		{
			sprintf(clnt_close, "q%s", name);
			str_len = sizeof(clnt_close);
			clnt_close[str_len] = 0;
			write(sock, clnt_close, sizeof(clnt_close));
			close(sock);
			exit(0);
		}
		sprintf(name_msg,"%s %s", name, msg);
		write(sock, name_msg, strlen(name_msg));
	}
	return NULL;
}
	
void error_handling(char *msg)
{
	fputs(msg, stderr);
	fputc('\n', stderr);
	exit(1);
}
