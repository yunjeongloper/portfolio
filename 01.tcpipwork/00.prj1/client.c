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
	char score[BUF_SIZE], result;
	int str_len;
	struct sockaddr_in serv_adr;
	int bingo[5][5];
	int i, j;

	if(argc!=3) {
		printf("Usage : %s <IP> <port>\n", argv[0]);
		exit(1);
	}
	
	sock=socket(PF_INET, SOCK_STREAM, 0);	 	//���ϻ���  
	if(sock==-1)
		error_handling("socket() error");
	
	memset(&serv_adr, 0, sizeof(serv_adr));		//����ü ���� serv_adr 0���� �ʱ�ȭ
	serv_adr.sin_family=AF_INET;				//�ּ�ü�� ����
	serv_adr.sin_addr.s_addr=inet_addr(argv[1]);//���ڿ� ����� IP�ּ� �ʱ�ȭ
	serv_adr.sin_port=htons(atoi(argv[2]));		//���ڿ� ����� PORT�ּ� �ʱ�ȭ
	
	if(connect(sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr))==-1)
		error_handling("connect() error!");
	
	for (i = 0; i < 5; i++){
		for (j = 0; j < 5; j++){
			bingo[i][j] = rand() % 25 + 1;
			printf("%d ", bingo[i][j]);
		}printf("\n");
	}
	
	/*for (i = 0; i < 3; i++)					//score�迭�� ���� �Է¹ް� ����
	{
		printf("Score %d : ", i + 1);
		scanf("%d", (int*)&score[i]);
	}

	write(sock, score, strlen(score));		//score�迭�� ��¹��ۿ� ����, ����

	read(sock, &result, 1);					//�Է� ���۸� ���� result���� ����

	printf("Grade : %c", result);			//result�� ���
	*/

	close(sock);
	return 0;
}

void error_handling(char *message)
{
	fputs(message, stderr);
	fputc('\n', stderr);
	exit(1);
}