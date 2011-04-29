class BlankSlate
  instance_methods.each { |m| undef_method m unless (m =~ /^__/ ) || (m =~/object_id/)}
end
