source bargs.sh "$@"

function subdomain_scanner($domain $wordlist)

{
  echo "Target domain: " $domain
  discovered_subdomains=()
  input=$wordlist
  while IFS= read -r line
  do
    subdomain=$line
    new_url=$subdomain'.'$subdomain
    echo $new_url
  done < "$input"

}

subdomain_scanner
