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
	
	sock=socket(PF_INET, SOCK_STREAM, 0);	 	//소켓생성  
	if(sock==-1)
		error_handling("socket() error");
	
	memset(&serv_adr, 0, sizeof(serv_adr));		//구조체 변수 serv_adr 0으로 초기화
	serv_adr.sin_family=AF_INET;				//주소체계 지정
	serv_adr.sin_addr.s_addr=inet_addr(argv[1]);//문자열 기반의 IP주소 초기화
	serv_adr.sin_port=htons(atoi(argv[2]));		//문자열 기반의 PORT주소 초기화
	
	if(connect(sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr))==-1)
		error_handling("connect() error!");
	
	for (i = 0; i < 5; i++){
		for (j = 0; j < 5; j++){
			bingo[i][j] = rand() % 25 + 1;
			printf("%d ", bingo[i][j]);
		}printf("\n");
	}
	
	/*for (i = 0; i < 3; i++)					//score배열에 점수 입력받고 저장
	{
		printf("Score %d : ", i + 1);
		scanf("%d", (int*)&score[i]);
	}

	write(sock, score, strlen(score));		//score배열을 출력버퍼에 쓰고, 전송

	read(sock, &result, 1);					//입력 버퍼를 거쳐 result값을 읽음

	printf("Grade : %c", result);			//result값 출력
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