{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "init.sql" ''
      CREATE ROLE pop;
    '';
    settings = {
      max_connections = 100;
      shared_buffers = "256MB";
      effective_cache_size = "768MB";
      work_mem = "4MB";
      maintenance_work_mem = "64MB";
      logging_collector = true;
      log_directory = "pg_log";
      log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
    };
  };
}
