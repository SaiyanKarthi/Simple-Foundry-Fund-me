-include .env
build:;forge build
deploy-sepolia:
      forge script script/DeployFundme.s.sol:DeployFundme --rpc-url $rpc_url --private-key $private_key --broadcast --verify --etherscan-api-key $etherscan-key -vvvv 