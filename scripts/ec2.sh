#!/bin/bash
cat <<EOF >/home/ubuntu/user-data.sh

#!/bin/bash
# Create a folder
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.298.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.2/actions-runner-linux-x64-2.298.2.tar.gz

# Validate the hash
echo "0bfd792196ce0ec6f1c65d2a9ad00215b2926ef2c416b8d97615265194477117  actions-runner-linux-x64-2.298.2.tar.gz" | shasum -a 256 -c

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.298.2.tar.gz

# Create the runner and start the configuration experience
curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer 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" \
  https://api.github.com/repos/havellaneda-ar/gh-test/actions/runners/registration-token > token_output.txt

token_runner=$(cat token_output.txt | grep -w "token" | cut -d'"' -f4)

./config.sh --url https://github.com/havellaneda-ar/gh-test --token ${token_runner}
./run.sh

EOF
cd /home/ubuntu
chmod +x user-data.sh
/bin/su -c "./user-data.sh" - ubuntu | tee /home/ubuntu/user-data.log
