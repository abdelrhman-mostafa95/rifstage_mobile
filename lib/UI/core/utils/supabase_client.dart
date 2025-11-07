import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://rewcjwephtaqabvpfyne.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJld2Nqd2VwaHRhcWFidnBmeW5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyNzM4NzQsImV4cCI6MjA3Njg0OTg3NH0.Yqn5-mskwb3Cl8IqmYFLY-U4mrE7NU3TlQ_z-EXcIKs',
  );
}
