# Deploy to localnetwork
forge script script/DeployLocal.s.sol --broadcast --fork-url localhost -vvv

forge script script/DeployTestnet.s.sol --broadcast --rpc-url goerli --verify  -vvv
