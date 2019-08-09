# Sync `shared` to longleaf
# Must be done with `rsync` so that code can be run before packages have
# been loaded
rsync -atuzv "/Users/lutz/Documents/julia/shared/" "lhendri@longleaf.unc.edu:/nas/longleaf/home/lhendri/julia/shared"

# ------------