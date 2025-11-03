import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async ({ deployments, getNamedAccounts }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("YourToken", {
    from: deployer,
    log: true,
    autoMine: true,
  });
};

export default func;
func.tags = ["YourToken"];
