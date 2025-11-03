import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployVendor: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy, log } = hre.deployments;
  const { ethers } = hre;

  log("----------------------------------------------------");
  log("Deploying YourToken and Vendor contracts...");

  // Deploy YourToken
  const yourTokenDeployment = await deploy("YourToken", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });
  const yourToken = await ethers.getContractAt("YourToken", yourTokenDeployment.address);

  // Deploy Vendor
  const vendorDeployment = await deploy("Vendor", {
    from: deployer,
    args: [yourTokenDeployment.address],
    log: true,
    autoMine: true,
  });
  const vendor = await ethers.getContractAt("Vendor", vendorDeployment.address);

  log(`Vendor deployed at: ${vendorDeployment.address}`);

  // Send tokens to vendor
  const tx1 = await yourToken.transfer(vendorDeployment.address, ethers.parseEther("1000"));
  await tx1.wait();
  log(`Transferred 1000 YTK to Vendor: ${vendorDeployment.address}`);

  // Transfer ownership to your frontend wallet (replace manually or via env)
  const frontendAddress = process.env.FRONTEND_OWNER || "0xYourFrontendWalletAddress";
  const tx2 = await vendor.transferOwnership(frontendAddress);
  await tx2.wait();
  log(`Vendor ownership transferred to: ${frontendAddress}`);

  log("----------------------------------------------------");
};

export default deployVendor;
deployVendor.tags = ["Vendor"];
