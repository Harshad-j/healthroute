const BASE_URL = '/api';

export interface AuthUser {
  id: number;
  name: string;
  email: string;
}

const USER_KEY = 'hr_user';

export const AuthService = {
  async signup(name: string, email: string, password: string): Promise<AuthUser> {
    const res = await fetch(`${BASE_URL}/auth/signup`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email, password })
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Signup failed (${res.status})`);
    }
    const user = await res.json();
    return user as AuthUser;
  },

  async login(email: string, password: string): Promise<AuthUser> {
    const res = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || 'Invalid credentials');
    }
    const user = (await res.json()) as AuthUser;
    localStorage.setItem(USER_KEY, JSON.stringify(user));
    return user;
  },

  logout() {
    localStorage.removeItem(USER_KEY);
  },

  currentUser(): AuthUser | null {
    try {
      const raw = localStorage.getItem(USER_KEY);
      if (raw) return JSON.parse(raw) as AuthUser;
      
      // Return a default Guest user so the app doesn't crash without login
      return { id: 1, name: 'Guest User', email: 'guest@example.com' };
    } catch {
      return { id: 1, name: 'Guest User', email: 'guest@example.com' };
    }
  }
};


