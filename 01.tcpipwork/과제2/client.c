#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define BUF_SIZE 1024

int main(int argc, char *argv[])
{
	int sock;
	int str_len;
	struct sockaddr_in serv_adr;
	char bingo[25];
	int a, b, c = 0;
	char cho[10] = { 0, };
	int fin[25] = { 0, };	// ���� �� ������ ��ġ�� ��

	if (argc != 3) {
		printf("Usage : %s <IP> <port>\n", argv[0]);
		exit(1);
	}

	sock = socket(PF_INET, SOCK_STREAM, 0);	 	//���ϻ���  
	if (sock == -1)
		error_handling("socket() error");

	memset(&serv_adr, 0, sizeof(serv_adr));		//����ü ���� serv_adr 0���� �ʱ�ȭ
	serv_adr.sin_family = AF_INET;				//�ּ�ü�� ����
	serv_adr.sin_addr.s_addr = inet_addr(argv[1]);//���ڿ� ����� IP�ּ� �ʱ�ȭ
	serv_adr.sin_port = htons(atoi(argv[2]));		//���ڿ� ����� PORT�ּ� �ʱ�ȭ

	srand(time(NULL));

	if (connect(sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr)) == -1)
		error_handling("connect() error!");

	for (a = 0; a < 25; a++){
		bingo[a] = rand() % 25 + 1;
		for (b = 0; b < a; b++){
			if (bingo[a] == bingo[b]){
				--a;
				break;
			}
		}
	}

	printf("\nBINGO START!\n\n");		//�ʱ� ������ ���

	for (c = 0; c < 25; c++){
		printf("%d\t", bingo[c]);
		if ((c + 1) % 5 == 0)
			printf("\n");
	}

	for (a = 0; a < 10; a++)					//���� ����
	{
		sleep(3);

		cho[(a * 2)] = (rand() % 25 + 1);		//client�� 1~25 �� �������� ���� ����(�ߺ�x)
		for (b = 0; b < (a * 2); b++){
			if (cho[(a * 2)] == cho[b]){
				cho[(a * 2)] = (rand() % 25 + 1);
				b--;
			}
		}

		printf("\n%d.client's choice : %d\n\n", (a * 2) + 1, cho[(a * 2)]);

		for (b = 0; b < 25; b++){		//���� �� ������ �迭�� ���ڿ�X�� ǥ������
			if (bingo[b] == cho[(a * 2)]){
				bingo[b] = 'X';
				fin[(a*2)] = b;
			}
		}

		for (b = 0; b < 25; b++){		//client�� ������ ���� ���� ���
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

		int garo;							//���� �� ���� Ȯ��
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
			cho[(a + 2)] = 99;
			write(sock, cho, BUF_SIZE);
			break;
		}

		int sero;							//���� �� ���� Ȯ��
		for (b = 0; b < 5; b++){
			sero = 0;
			for (c = 1; c < 5; c++){
				if (bingo[b] == 'X'){
					if (bingo[b] == bingo[b+ 5* c])
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
			cho[(a + 2)] = 99;
			write(sock, cho, BUF_SIZE);
			break;
		}

		sleep(1);
		write(sock, cho, BUF_SIZE);				//server���� ���� �� ����

		read(sock, cho, BUF_SIZE);				//server�κ��� ���� �� ����

		if (cho[(a * 2)+1] == 99)
			break;

		printf("%d. server's choice : %d\n\n", (a + 1) * 2, cho[(a * 2) + 1]);

		for (b = 0; b < 25; b++){				//���� �� ������ �迭 ��ġ�� ã�Ƽ� ���ڿ�X�� ǥ������
			if (bingo[b] == cho[(a * 2) + 1]){
				bingo[b] = 'X';
				fin[(a * 2)+1] = b;
			}
		}

		for (b = 0; b < 25; b++){				//server�� ������ ���ڸ� üũ�� ������ �ٽ� ǥ��
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

		for (b = 0; b < 5; b++){				//���� ���� Ȯ��
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
			cho[(a + 1)*2] = 99;
			write(sock, cho, BUF_SIZE);
			break;
		}

		for (b = 0; b < 5; b++){				//���� ���� Ȯ��
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
			cho[(a + 1)*2] = 99;
			write(sock, cho, BUF_SIZE);
			break;
		}
	}

	close(sock);
	return 0;
}
