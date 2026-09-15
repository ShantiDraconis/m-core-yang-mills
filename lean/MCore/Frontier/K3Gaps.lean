import MCore.K3

namespace MCore

structure FrontierBridge where
  id : String
  target : CertNode
  status : SignatureStatus

def k3_frontier : FrontierBridge :=
  { id := "K3_predicted_gap"
    target := k3_gap_node
    status := .openBridge }

theorem k3_frontier_open : k3_frontier.status = .openBridge := rfl

end MCore
