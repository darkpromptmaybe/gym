import { neon } from '@neondatabase/serverless';

if (!process.env.DATABASE_URL) {
  throw new Error('DATABASE_URL environment variable is not set');
}

// Create base SQL connection
export const sql = neon(process.env.DATABASE_URL);

// Create authenticated SQL connection with JWT for Neon Authorize
export function getAuthenticatedSql(authToken?: string) {
  if (!authToken) {
    return sql;
  }
  
  // Neon Authorize: Set JWT token for row-level security
  return neon(process.env.DATABASE_URL!, {
    authToken: authToken,
  });
}

export async function testConnection() {
  try {
    const result = await sql`SELECT NOW()`;
    console.log('✅ Database connected:', result[0]);
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    return false;
  }
}
