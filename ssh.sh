#!/bin/bash
# Verifica se o arquivo ips.txt existe
if [ ! -f ips.txt ]; then
    echo "Arquivo ips.txt não encontrado!"
    exit 1
fi

# Loop para ler cada IP do arquivo ips.txt
while IFS= read -r ip; do
    echo "Testando conexão SSH em: $ip..."

    # Executa o expect para testar a conexão SSH
    expect <<EOF
    set timeout 1
    spawn ssh -o ConnectTimeout=5 sfm@$ip exit
    expect {
        -re "(?i)password:" {
            send_user "Conexão SSH em $ip solicitou senha.\n"
            send "\003"
        }
        timeout {
            send_user "Timeout: Não foi possível conectar a $ip.\n"
        }
        eof {
            # Caso a conexão seja imediatamente encerrada sem prompt
        }
    }
EOF

done < ips.txt