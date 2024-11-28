{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [ 
    
    # Build tools

    git 
    cmake
    gcc
    ninja
    nodejs
    # psutil
    

    # Python dev tools
    python311Packages.pip
    python311Packages.virtualenv
    python311Packages.pytorch
    python311Packages.pytorch-lightning
    python311Packages.psutil
    python311Packages.fastapi
    python311Packages.pydantic
    python311Packages.uvicorn

    # CUDA support (if needed)
    # cudaPackages.cuda_11_7
    # cudaPackages.cudnn
    ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # Python/Pip
    languages.python = {
    enable = true;
    venv.enable = true;
    venv.requirements = ''
      pip
      fastapi
      pydantic
      uvicorn
      sse-starlette
      tiktoken
      mido
      midi2audio
      python-multipart
    '';
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    echo "RWKV-LM development environment"
    echo "Python $(python --version)"
    git --version
    python -c "import pip" && echo "No errors!"

    # Build frontend first
    if [ ! -d "frontend/dist" ]; then
      echo "Building frontend..."
      (cd frontend && npm ci && npm run build)
    fi

    # Then start the server
    python ./backend-python/main.py --webui
  '';


    # Add appropriate command (below) to enterShell (above) for the desired environment

    # Install additional Python packages via pip if they don't exist
    # python ./backend-python/main.py #The backend inference service has been started, request /switch-model API to load the model, refer to the API documentation: http://127.0.0.1:8000/docs
    # # Or 
    # cd RWKV-Runner/frontend
    # npm ci
    # npm run build #Compile the frontend
    # cd ..
    # python ./backend-python/webui_server.py #Start the frontend service separately
    # # Or
    # python ./backend-python/main.py --webui #Start the frontend and backend service at the same time
    # Help Info
    # python ./backend-python/main.py -h


  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
