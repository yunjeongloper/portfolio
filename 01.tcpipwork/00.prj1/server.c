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
	int serv_sock, clnt_sock;
	char score[BUF_SIZE], grade;
	int result, sum, i, j; 
	int bingo[5][5];

	struct sockaddr_in serv_adr;
	struct sockaddr_in clnt_adr;
	socklen_t clnt_adr_sz;
	
	if(argc!=2) {
		printf("Usage : %s <port>\n", argv[0]);
		exit(1);
	}
	
	serv_sock=socket(PF_INET, SOCK_STREAM, 0);	//���ϻ���
	if(serv_sock==-1)
		error_handling("socket() error");
	
	memset(&serv_adr, 0, sizeof(serv_adr));		//����ü ���� serv_adr 0���� �ʱ�ȭ
	serv_adr.sin_family=AF_INET;				//�ּ�ü�� ����
	serv_adr.sin_addr.s_addr=htonl(INADDR_ANY);	//���ڿ� ����� IP�ּ� �ʱ�ȭ
	serv_adr.sin_port=htons(atoi(argv[1]));		//���ڿ� ����� PORT�ּ� �ʱ�ȭ

	if(bind(serv_sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr))==-1)
		error_handling("bind() error");
	
	if(listen(serv_sock, 5)==-1)
		error_handling("listen() error");

	clnt_adr_sz=sizeof(clnt_adr);
	clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_adr, &clnt_adr_sz);
	if(clnt_sock==-1)
		error_handling("accept() error");

	for (i = 0; i < 5; i++){
		for (j = 0; j < 5; j++){
			bingo[i][j] = rand() % 25 + 1;
			printf("%d ", bingo[i][j]);
		}printf("\n");
	}

	/*read(clnt_sock, score, BUF_SIZE);	//�Է� ���۸� ���� score�迭�� ����

	for (i = 0; i < 3; i++){			//�о���� ���� ��� ���ϱ�
		sum += score[i];
	}

	result = sum / 3;					//��� ���ϱ�

	if (result >= 90)
		grade = 'A';
	else if (result < 90 && result >= 80)
		grade = 'B';
	else if (result < 80 && result >= 70)
		grade = 'C';
	else if (result < 70 && result >= 60)
		grade = 'D';
	else
		grade = 'F';					//���� ���ϱ�
	
	write(clnt_sock, (char*)&grade, 1);	//���� ������ ��� ���ۿ� ����, ����*/

	close(clnt_sock);

	close(serv_sock);

	return 0;
}

void error_handling(char *score)
{
	fputs(score, stderr);
	fputc('\n', stderr);
	exit(1);
}