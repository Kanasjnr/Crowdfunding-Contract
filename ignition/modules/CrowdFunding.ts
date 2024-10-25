import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const goal = 5;

const crowdFundingModule = buildModule("CrowdfundingModule", (m) => {
  const crowdFunding = m.contract("crowdFunding", [goal]);

  return { crowdFunding };
});

export default crowdFundingModule;


