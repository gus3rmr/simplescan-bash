source bargs.sh "$@"

function subdomain_scanner($domain $wordlist)

{
  echo ""
  echo -e "-Target domain: ${domain}\n"
  discovered_subdomains=()
  subdomains_file_name=$domain'_subdomains.txt'
  input=$wordlist
  while IFS= read -r line
  do
    subdomain=$line
    new_url=$subdomain'.'$domain
    status_code=$(curl -o /dev/null -s -w "%{http_code}\n" https://$new_url)
    if [[ "$status_code" -eq 200 || "$status_code" -eq 301 ]]
    then
      echo '[*] Found: '$new_url', status: '$status_code
      discovered_subdomains+="\n${new_url}"
    else
      continue
    fi
  done < "$input"
  echo -e "\n-Discovered subdomains:"
  echo -e "${discovered_subdomains}"
  echo -e "\nCreating or updating the file with the subdomains found..."

  if [[ -f "$subdomains_file_name" ]]
  then
    echo "Updating file..."
    echo "$discovered_subdomains" > "$subdomains_file_name"
    echo "File $subdomains_file_name has been updated."
  else
    echo "Creating file..."
    touch "$subdomains_file_name"
    echo "$discovered_subdomains" > "$subdomains_file_name"
    echo "File $subdomains_file_name has been created."
  fi

  echo ""
}

subdomain_scanner
