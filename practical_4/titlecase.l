#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>            // close()
#include <arpa/inet.h>         // sockaddr_in, inet_ntoa()
#include <errno.h>

#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    char buffer[BUFFER_SIZE];
    socklen_t addr_len = sizeof(client_addr);

    // 1. Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // 2. Prepare server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;          // IPv4
    server_addr.sin_addr.s_addr = INADDR_ANY;  // Any interface
    server_addr.sin_port = htons(PORT);        // Server port

    // 3. Bind the socket to the address
    if (bind(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("✅ UDP Echo Server started on port %d\n", PORT);

    // 4. Handle incoming datagrams
    while (1) {
        ssize_t n = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                             (struct sockaddr*)&client_addr, &addr_len);
        if (n < 0) {
            perror("recvfrom() failed");
            continue;
        }

        buffer[n] = '\0'; // Null-terminate the message
        printf("📨 Received from %s:%d → \"%s\"\n",
               inet_ntoa(client_addr.sin_addr),
               ntohs(client_addr.sin_port),
               buffer);

        // Echo the data back to the client
        if (sendto(sockfd, buffer, n, 0, (struct sockaddr*)&client_addr, addr_len) != n) {
            perror("sendto() failed");
        }
    }

    close(sockfd);
    return 0;
}




Client Side:
// udp_echo_client.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>            // close()
#include <arpa/inet.h>         // sockaddr_in, inet_pton()
#include <errno.h>

#define SERVER_IP "127.0.0.1"  // Localhost
#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];
    socklen_t addr_len = sizeof(server_addr);

    // 1. Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // 2. Setup server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;             // IPv4
    server_addr.sin_port = htons(PORT);           // Server port

    if (inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr) <= 0) {
        perror("Invalid server IP address");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("🔗 Connected to UDP server %s:%d\n", SERVER_IP, PORT);
    printf("Type messages (or 'exit' to quit):\n");

    while (1) {
        printf("> ");
        if (fgets(buffer, BUFFER_SIZE, stdin) == NULL) {
            printf("Input error or EOF. Exiting.\n");
            break;
        }

        buffer[strcspn(buffer, "\n")] = '\0'; // Strip newline

        if (strcmp(buffer, "exit") == 0)
            break;

        // Send message
        ssize_t sent_len = sendto(sockfd, buffer, strlen(buffer), 0,
                                  (struct sockaddr*)&server_addr, addr_len);
        if (sent_len < 0) {
            perror("sendto() failed");
            continue;
        }

        // Receive echo
        ssize_t recv_len = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                    NULL, NULL);
        if (recv_len < 0) {
            perror("recvfrom() failed");
            continue;
        }

        buffer[recv_len] = '\0'; // Null-terminate response
        printf("🔁 Server echoed: \"%s\"\n", buffer);
    }

    close(sockfd);
    return 0;
}
