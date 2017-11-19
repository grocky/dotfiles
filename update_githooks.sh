for project in $(find . -type d -maxdepth 2 -name .git); do 
  project_dir=$(realpath $(dirname ${project})); 
  cd ${project_dir}; 
  echo "Updating hooks for $(basename ${project_dir})"; 
  rm .git/hooks/post-commit*; 
  git init >/dev/null; 
  cd - >/dev/null;  
done

