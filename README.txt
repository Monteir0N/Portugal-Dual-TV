PORTUGAL DUAL TV — mHub addon + player de dois ecrãs
===================================================

IMPORTANTE
----------
O catálogo incluído tem apenas um canal de exemplo para testar o formato
da source URL. O script PowerShell gera o catálogo completo a partir da
origem geil.to no teu computador.

A source URL gerada tem este formato:
https://www.geil.to/live/resolve?url=<URL_PLAY_ENCODED>

O resolver que testaste devolve JSON com "url", "live", "format" e "name".
Ainda não está confirmado que o mHub interpreta automaticamente esse JSON
quando o endereço é colocado diretamente em sources. Este pacote permite
testar essa hipótese, mas não a assume como garantida.

1. GERAR O CATÁLOGO COMPLETO
----------------------------
Abre PowerShell na pasta extraída e executa:

  powershell -ExecutionPolicy Bypass -File .\tools\build-catalog.ps1

O script descarrega os canais portugueses e atualiza:
  .\catalog\live\portugal.json

2. PUBLICAR O ADDON
-------------------
Publica a pasta completa num servidor web estático, mantendo a estrutura.
Depois adiciona ao mHub o URL público de:

  https://TEU-DOMINIO/Portugal-Dual-TV/mhub-addon.json

A localização exata depende de onde publicares a pasta.

3. PLAYER DE DOIS ECRÃS
-----------------------
Abre:
  https://TEU-DOMINIO/Portugal-Dual-TV/player/

O player usa o mesmo catálogo e chama o resolver para obter o URL HLS
de cada canal. Os dois vídeos são independentes.

4. NOTAS / LIMITAÇÕES
---------------------
- O player pode ser bloqueado por CORS ao chamar o resolver a partir do
  browser. Se acontecer, será necessário um pequeno proxy/backend.
- O browser precisa de suportar HLS através de hls.js ou nativamente.
- A reprodução simultânea depende também de o servidor de origem permitir
  duas ligações ao mesmo tempo.
- A compatibilidade direta do resolver JSON com o mHub precisa de ser
  confirmada num teste real. Se o mHub exigir uma resposta de resolução
  própria, será necessário implementar um resolver compatível com o
  protocolo, em vez de usar o endpoint JSON diretamente como source.
