
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Mail, Lock, ArrowRight, Loader2, PlayCircle } from 'lucide-react';
import { apiService } from '../services/apiService';

interface AuthModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (token: string) => void;
}

export const AuthModal: React.FC<AuthModalProps> = ({ isOpen, onClose, onSuccess }) => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        try {
            // Step 1: Try signup
            let data;
            try {
                data = await apiService.signup(email, password);
            } catch (signupErr: any) {
                // Step 2: Fallback to login if user already exists
                if (signupErr.message.includes('already exists')) {
                    data = await apiService.login(email, password);
                } else {
                    throw signupErr;
                }
            }

            const { token } = data;
            localStorage.setItem('auth_token', token);
            onSuccess(token);
        } catch (err: any) {
            setError(err.message || 'Authentication failed');
        } finally {
            setLoading(false);
        }
    };

    return (
        <AnimatePresence>
            {isOpen && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={onClose}
                        className="absolute inset-0 bg-black/80 backdrop-blur-sm"
                    />

                    <motion.div
                        initial={{ opacity: 0, scale: 0.95, y: 20 }}
                        animate={{ opacity: 1, scale: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.95, y: 20 }}
                        className="relative w-full max-w-md glass-panel rounded-[32px] p-8 shadow-2xl border border-white/10"
                    >
                        <button
                            onClick={onClose}
                            className="absolute top-6 right-6 p-2 rounded-full hover:bg-white/5 transition-colors"
                        >
                            <X className="w-5 h-5 text-zinc-500" />
                        </button>

                        <div className="text-center space-y-3 mb-8">
                            <div className="inline-flex items-center justify-center w-12 h-12 rounded-2xl bg-[#D4AF37]/10 mb-2">
                                <PlayCircle className="w-6 h-6 text-[#D4AF37]" />
                            </div>
                            <h2 className="text-3xl font-black tracking-tighter uppercase italic">Secure Results</h2>
                            <p className="text-zinc-500 font-medium">Create an account to save your Financial DNA.</p>
                        </div>

                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div className="space-y-2">
                                <label className="text-[10px] font-black uppercase tracking-widest text-[#D4AF37] px-1">Email Address</label>
                                <div className="relative">
                                    <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-zinc-500" />
                                    <input
                                        type="email"
                                        required
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        className="w-full bg-zinc-900/50 border border-zinc-800 rounded-2xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-[#D4AF37] transition-all font-medium"
                                        placeholder="name@example.com"
                                    />
                                </div>
                            </div>

                            <div className="space-y-2">
                                <label className="text-[10px] font-black uppercase tracking-widest text-[#D4AF37] px-1">Password</label>
                                <div className="relative">
                                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-zinc-500" />
                                    <input
                                        type="password"
                                        required
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        className="w-full bg-zinc-900/50 border border-zinc-800 rounded-2xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-[#D4AF37] transition-all font-medium"
                                        placeholder="••••••••"
                                    />
                                </div>
                            </div>

                            {error && (
                                <motion.div
                                    initial={{ opacity: 0, y: -10 }}
                                    animate={{ opacity: 1, y: 0 }}
                                    className="bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-bold py-3 px-4 rounded-xl text-center"
                                >
                                    {error}
                                </motion.div>
                            )}

                            <button
                                type="submit"
                                disabled={loading}
                                className="w-full gold-gradient text-black font-black py-5 rounded-2xl flex items-center justify-center gap-2 text-lg active:scale-95 transition-all shadow-[0_15px_30px_rgba(212,175,55,0.2)] disabled:opacity-50 mt-4 group"
                            >
                                {loading ? (
                                    <Loader2 className="w-6 h-6 animate-spin" />
                                ) : (
                                    <>
                                        SECURE ACCESS
                                        <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                                    </>
                                )}
                            </button>
                        </form>

                        <div className="mt-8 text-center">
                            <p className="text-[10px] text-zinc-600 font-bold uppercase tracking-[0.2em] leading-relaxed">
                                By continuing, you agree to MoneyVibe's<br />
                                <span className="text-[#D4AF37]">Terms of Intelligence</span> & <span className="text-[#D4AF37]">Privacy Protocol</span>
                            </p>
                        </div>
                    </motion.div>
                </div>
            )}
        </AnimatePresence>
    );
};
