
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define BUF_SIZE 1024

void error_handling(char *score);

int main(int argc, char *argv[])
{
	int serv_sock, clnt_sock;
	char cho[BUF_SIZE], grade;
	char bingo[25];
	int a, b, c = 0;
	int fin[10] = { 0, };	// 선택 된 숫자의 위치가 들어감

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

	srand(time(NULL));

	clnt_adr_sz=sizeof(clnt_adr);
	clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_adr, &clnt_adr_sz);
	if(clnt_sock==-1)
		error_handling("accept() error");

	for (a = 0; a < 25; a++){				//초기 빙고판 생성
		bingo[a] = rand() % 25 + 1;
		for (b = 0; b < a; b++){
			if (bingo[a] == bingo[b]){
				--a;
				break;
			}
		}
	}

	printf("\nBINGO START!\n\n");

	for (a = 0; a < 25; a++){			
		printf("%d\t", bingo[a]);
		if ((a + 1) % 5 == 0)
			printf("\n");
	}

	for (a = 0; a < 10; a++){			//빙고 게임 전개

		sleep(1);

		read(clnt_sock, cho, BUF_SIZE);	//client 읽어옴
		
		if (cho[(a * 2)] == 99)
			break;

		printf("\n%d. client's choice : %d\n\n", ((a*2) + 1), cho[(a*2)]);

		for (b = 0; b < 25; b++)		//선택 된 숫자와 값이 같은 빙고배열을 찾아서 문자열X로 표시해줌
			if (bingo[b] == cho[(a * 2)]){
				bingo[b] = 'X';
				fin[(a*2)] = b;
			}

		for (b = 0; b < 25; b++){		//client가 선택한 후의 빙고 출력
			for (c = 0; c < (a * 2) + 1; c++){
				if (b == fin[c] && c < (a * 2) + 1){
					printf("%c\t", bingo[b]);
					if ((b + 1) % 5 == 0)
						printf("\n");
					break;
				}
				else if (b != fin[c] && c == (a * 2)){
					printf("%d\t", bingo[b]);
					if ((b + 1) % 5 == 0)
						printf("\n");
				}
				else if (b != fin[c] && c < (a * 2) + 1){
					continue;
				}
			}
		}
		printf("\n");

		int garo;						//가로 빙고 확인
		for (b = 0; b < 5; b++){
			garo = 0;
			if (bingo[b * 5] == 'X'){
				for (c = 1; c < 5; c++){
					if (bingo[b * 5] == bingo[b * 5 + c])
						garo++;
					if (garo == 4)
						break;
				}
			}
			if (garo == 4)
				break;
		}
		if (garo == 4){
			printf("\n-----garobingo!-----\n");
			cho[(a + 2)+1] = 99;
			write(clnt_sock, cho, BUF_SIZE);
			break;
		}

		int sero;						//세로 빙고 확인
		for (b = 0; b < 5; b++){
			sero = 0;
			for (c = 1; c < 5; c++){
				if (bingo[b] == 'X'){
					if (bingo[b] == bingo[b + 5 * c])
						sero++;
					if (sero == 4)
						break;
				}
			}
			if (sero == 4)
				break;
		}
		if (sero == 4){
			printf("\n-----serobingo!-----\n");
			cho[(a + 2)+1] = 99;
			write(clnt_sock, cho, BUF_SIZE);
			break;
		}

		sleep(3);

		cho[(a * 2)+1] = (rand() % 25 + 1);		//1~25 중 랜덤으로 숫자 선택(중복x)
		for (b = 0; b < (a * 2)+1; b++){
			if (cho[(a * 2)+1] == cho[b]){
				cho[(a * 2)+1] = (rand() % 25 + 1);
				b--;
			}
		}

		printf("%d. server's choice : %d\n\n", (a+1)*2, cho[(a * 2) + 1]);

		for (b = 0; b < 25; b++){				//선택 된 숫자의 배열 위치를 찾아서 문자열X로 표시해줌
			if (bingo[b] == cho[(a * 2) + 1]){
				bingo[b] = 'X';
				fin[(a * 2) + 1] = b;
			}
		}

		for (b = 0; b < 25; b++){				//server가 선택한 숫자를 체크한 빙고판 다시 표시
			for (c = 0; c < (a * 2) + 2; c++){
				if (b == fin[c] && c < (a * 2) + 2){
					printf("%c\t", bingo[b]);
					if ((b + 1) % 5 == 0)
						printf("\n");
					break;
				}
				else if (b != fin[c] && c == (a * 2) + 1){
					printf("%d\t", bingo[b]);
					if ((b + 1) % 5 == 0)
						printf("\n");
				}
				else if (b != fin[c] && c < (a * 2) + 2){
					continue;
				}
			}
		}

		for (b = 0; b < 5; b++){
			garo = 0;
			if (bingo[b * 5] == 'X'){
				for (c = 1; c < 5; c++){
					if (bingo[b * 5] == bingo[b * 5 + c])
						garo++;
					if (garo == 4)
						break;
				}
			}
			if (garo == 4)
				break;
		}
		if (garo == 4){
			printf("\n-----garobingo!-----\n");
			cho[(a + 2) + 1] = 99;
			write(clnt_sock, cho, BUF_SIZE);
			break;
		}

		for (b = 0; b < 5; b++){
			sero = 0;
			for (c = 1; c < 5; c++){
				if (bingo[b] == 'X'){
					if (bingo[b] == bingo[b + 5 * c])
						sero++;
					if (sero == 4)
						break;
				}
			}
			if (sero == 4)
				break;
		}
		if (sero == 4){
			printf("\n-----serobingo!-----\n");
			cho[(a + 2) + 1] = 99;
			write(clnt_sock, cho, BUF_SIZE);
			break;
		}

		sleep(2);
		write(clnt_sock, cho, BUF_SIZE);		

	}

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