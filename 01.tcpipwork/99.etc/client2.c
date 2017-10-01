#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <time.h>

#define BUFSIZE 100

void error_handling(char *message);

int main(int argc, char **argv)
{
	int sock;
	char message[BUFSIZE];
	int str_len;
	char arr[25], bingo[5][5];
	int a, b, c = 0;
	char cho[20] = { 0, };

	struct sockaddr_in serv_addr;

	if (argc != 3){
		printf("Usage : %s <IP> <port>\n", argv[0]);
		exit(1);
	}

	sock = socket(PF_INET, SOCK_STREAM, 0);

	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
	serv_addr.sin_port = htons(atoi(argv[2]));

	if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1)
		error_handling("connect() error!");

	srand(time(NULL));

	read(sock, message, BUFSIZE);
	printf("client%s access\n", message);

	for (a = 0; a < 25; a++){				//초기 빙고판 생성
		arr[a] = rand() % 25 + 1;
		for (b = 0; b < a; b++){
			if (arr[a] == arr[b]){
				--a;
				break;
			}
		}
	}
	for (a = 0; a < 5; a++){
		for (b = 0; b < 5; b++){
			bingo[a][b] = arr[a * 5 + b];
		}
	}

	printf("\nBINGO START!\n\n");

	for (a = 0; a < 5; a++){
		for (b = 0; b < 5; b++){
			printf("%d\t", bingo[a][b]);
		}
		printf("\n");
	}

	for (a = 0; a < 20; a++){		//게임 시작
		sleep(2);

		read(sock, message, BUFSIZE);	//client 읽어옴
		if (message[0] == 99){
			printf("YOU LOSE TT");
			break;
		}
		cho[(a * 2)] = message[0];
		printf("\n%d. client's choice : %d\n\n", ((a * 2) + 1), cho[(a * 2)]);

		for (b = 0; b < 5; b++){
			for (c = 0; c < 5; c++){
				if (bingo[b][c] == cho[(a * 2)]){
					bingo[b][c] = 'X';
				}
			}
		}

		for (b = 0; b < 5; b++){
			for (c = 0; c < 5; c++){
				if (bingo[b][c] == 'X')
					printf("%c\t", bingo[b][c]);
				else
					printf("%d\t", bingo[b][c]);
			}printf("\n");
		}

		int fin = 0;
		int garo = 0;
		for (b = 0; b < 5; b++){
			garo = 0;
			for (c = 1; c < 5; c++){
				if (bingo[b][0] == bingo[b][c]){
					garo++;
					if (garo == 4){
						fin++;
					}
				}
			}
		}
		int sero = 0;
		for (b = 0; b < 5; b++){
			sero = 0;
			for (c = 1; c < 5; c++){
				if (bingo[0][b] == bingo[c][b]){
					sero++;
					if (sero == 4){
						fin++;
					}
				}
			}
		}
		int cross1 = 0;
		for (b = 1; b < 5; b++){
			if (bingo[0][0] == bingo[b][b]){
				cross1++;
				if (cross1 == 4){
					fin++;
				}
			}
		}
		int cross2 = 0;
		for (b = 1; b < 5; b++){
			if (bingo[0][4] == bingo[b][4 - b]){
				cross2++;
				if (cross2 == 4){
					fin++;
				}
			}
		}
		if (fin == 5){
			printf("BINGO FINISH!\n  YOU WIN!");
			message[0] = 99;
			write(sock, message, BUFSIZE);
			break;
		}

		sleep(3);

		cho[(a * 2) + 1] = (rand() % 25 + 1);		//1~25 중 랜덤으로 숫자 선택(중복x)
		for (b = 0; b < (a * 2)+1; b++){
			here:
			if (cho[(a * 2)+1] == cho[b]){
				cho[(a * 2)+1] = (rand() % 25 + 1);
				goto here;
			}
		}
		printf("\n%d. server's choice : %d\n\n", (a + 1) * 2, cho[(a * 2) + 1]);

		for (b = 0; b < 5; b++){
			for (c = 0; c < 5; c++){
				if (bingo[b][c] == cho[(a * 2) + 1]){
					bingo[b][c] = 'X';
				}
			}
		}

		for (b = 0; b < 5; b++){
			for (c = 0; c < 5; c++){
				if (bingo[b][c] == 'X')
					printf("%c\t", bingo[b][c]);
				else
					printf("%d\t", bingo[b][c]);
			}printf("\n");
		}
		
		fin = 0;
		garo = 0;
		for (b = 0; b < 5; b++){
			garo = 0;
			for (c = 1; c < 5; c++){
				if (bingo[b][0] == bingo[b][c]){
					garo++;
					if (garo == 4){
						fin++;
					}
				}
			}
		}
		sero = 0;
		for (b = 0; b < 5; b++){
			sero = 0;
			for (c = 1; c < 5; c++){
				if (bingo[0][b] == bingo[c][b]){
					sero++;
					if (sero == 4){
						fin++;
					}
				}
			}
		}
		cross1 = 0;
		for (b = 1; b < 5; b++){
			if (bingo[0][0] == bingo[b][b]){
				cross1++;
				if (cross1 == 4){
					fin++;
				}
			}
		}
		cross2 = 0;
		for (b = 1; b < 5; b++){
			if (bingo[0][4] == bingo[b][4 - b]){
				cross2++;
				if (cross2 == 4){
					fin++;
				}
			}
		}
		if (fin == 5){
			printf("BINGO FINISH!\n  YOU WIN!");
			message[0] = 99;
			write(sock, message, BUFSIZE);
			break;
		}
		message[0] = cho[(a * 2) + 1];
		write(sock, message, BUFSIZE);

	}
	printf("%s win\n", message);
	close(sock);
	return 0;
}

void error_handling(char *message)
{
	fputs(message, stderr);
	fputc('\n', stderr);
	exit(1);
}