require('dotenv').config();
const readline = require('readline');
const bcrypt = require('bcryptjs');
const { Pool } = require('pg');
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const ask = q => new Promise(resolve => rl.question(q, resolve));
async function hiddenAsk(prompt) {
  if (!process.stdin.isTTY || !process.stdin.setRawMode) return ask(prompt);
  return new Promise(resolve => {
    let value=''; rl.pause(); process.stdout.write(prompt); process.stdin.setRawMode(true); process.stdin.resume();
    const onData = data => { const c=data.toString(); if(c==='\u0003'){process.exit(1);} if(c==='\r'||c==='\n'){process.stdin.setRawMode(false);process.stdin.pause();process.stdin.removeListener('data',onData);process.stdout.write('\n');rl.resume();resolve(value);} else if(c==='\u007f'){value=value.slice(0,-1);} else {value+=c;} };
    process.stdin.on('data',onData);
  });
}
(async()=>{
  if(!process.env.DATABASE_URL) throw new Error('DATABASE_URL is missing in .env');
  const name=(await ask('Owner name: ')).trim();
  const email=(await ask('Owner email: ')).trim().toLowerCase();
  const password=await hiddenAsk('Owner password (minimum 12 characters): ');
  if(name.length<2||!/^\S+@\S+\.\S+$/.test(email)||password.length<12) throw new Error('Enter a valid name/email and a password of at least 12 characters.');
  const pool=new Pool({connectionString:process.env.DATABASE_URL,ssl:process.env.DATABASE_URL.includes('localhost')?false:{rejectUnauthorized:false}});
  try { const hash=await bcrypt.hash(password,12); const r=await pool.query(`INSERT INTO users(name,email,password_hash,role,is_active) VALUES($1,$2,$3,'admin',TRUE) ON CONFLICT(email) DO UPDATE SET name=EXCLUDED.name,password_hash=EXCLUDED.password_hash,role='admin',is_active=TRUE,updated_at=NOW() RETURNING email,role`,[name,email,hash]); console.log(`Owner account ready: ${r.rows[0].email} (${r.rows[0].role})`); }
  finally { await pool.end(); rl.close(); }
})().catch(e=>{console.error(e.message);rl.close();process.exit(1);});
