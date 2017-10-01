#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define BUF_SIZE 1024
void error_handling(char *score);

int main(int argc, char *argv[])
{
	int sock;
	char score[BUF_SIZE];
	int str_len;
	struct sockaddr_in serv_adr;

	if(argc!=3) {
		printf("Usage : %s <IP> <port>\n", argv[0]);
		exit(1);
	}
	
	sock=socket(PF_INET, SOCK_STREAM, 0);   
	if(sock==-1)
		error_handling("socket() error");
	
	memset(&serv_adr, 0, sizeof(serv_adr));
	serv_adr.sin_family=AF_INET;
	serv_adr.sin_addr.s_addr=inet_addr(argv[1]);
	serv_adr.sin_port=htons(atoi(argv[2]));
	
	if(connect(sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr))==-1)
		error_handling("connect() error!");
	else
		puts("Connected...........");
	
	while(1) 
	{
		fputs("Input score: ", stdout);
		fgets(score, BUF_SIZE, stdin);

		printf("%d",BUF_SIZE)

		if(!strcmp(score,"q\n") || !strcmp(score,"Q\n"))
			break;

		write(sock, score, strlen(score));
		str_len=read(sock, score, BUF_SIZE-1);
		//write한 메세지 그대로read
		score[str_len]=0;
		//배열 초기화
		printf("Message from server: %s", score);
	}
	
	close(sock);
	return 0;
}

void error_handling(char *message)
{
	fputs(message, stderr);
	fputc('\n', stderr);
	exit(1);
}