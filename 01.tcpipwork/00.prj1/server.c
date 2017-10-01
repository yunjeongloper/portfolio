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
	
	serv_sock=socket(PF_INET, SOCK_STREAM, 0);	//소켓생성
	if(serv_sock==-1)
		error_handling("socket() error");
	
	memset(&serv_adr, 0, sizeof(serv_adr));		//구조체 변수 serv_adr 0으로 초기화
	serv_adr.sin_family=AF_INET;				//주소체계 지정
	serv_adr.sin_addr.s_addr=htonl(INADDR_ANY);	//문자열 기반의 IP주소 초기화
	serv_adr.sin_port=htons(atoi(argv[1]));		//문자열 기반의 PORT주소 초기화

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

	/*read(clnt_sock, score, BUF_SIZE);	//입력 버퍼를 거쳐 score배열을 읽음

	for (i = 0; i < 3; i++){			//읽어들인 값을 모두 더하기
		sum += score[i];
	}

	result = sum / 3;					//평균 구하기

	if (result >= 90)
		grade = 'A';
	else if (result < 90 && result >= 80)
		grade = 'B';
	else if (result < 80 && result >= 70)
		grade = 'C';
	else if (result < 70 && result >= 60)
		grade = 'D';
	else
		grade = 'F';					//학점 구하기
	
	write(clnt_sock, (char*)&grade, 1);	//구한 학점을 출력 버퍼에 쓰고, 전송*/

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