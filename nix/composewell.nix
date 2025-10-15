with import ./sources.nix;

let
  cw = "composewell";
  master = "master";

  composewellBranchFlags = repo: rev: branch: flags:
    githubBranchFlags cw repo rev branch flags;
  composewellFlags = repo: rev: flags:
    composewellBranchFlags repo rev master flags;
  composewellBranch = repo: rev: branch:
    composewellBranchFlags repo rev branch [];
  composewellSubdir = repo: rev: subdir:
    githubSubdir cw repo rev subdir;
  composewell = repo: rev:
    composewellFlags repo rev [];
in
{
  inherit composewellBranchFlags;
  inherit composewellFlags;
  inherit composewellBranch;
  inherit composewellSubdir;
  inherit composewell;
}
