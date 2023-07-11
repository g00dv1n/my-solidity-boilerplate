# Deploy to localnetwork
forge script script/DeployLocal.s.sol --broadcast --fork-url localhost -vvv

# local deployment with https://github.com/blacksmith-eth/blacksmith
forge script script/DeployLocal.s.sol --broadcast --fork-url localhost -vvv \
  --verify \
  --verifier-url http://localhost:3000/api/verify \
  --verifier sourcify

forge script script/DeployTestnet.s.sol --broadcast --rpc-url goerli --verify  -vvv
