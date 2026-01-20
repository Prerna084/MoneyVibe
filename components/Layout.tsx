
import React from 'react';
import { ChevronLeft } from 'lucide-react';

interface LayoutProps {
  children: React.ReactNode;
  title?: string;
  onBack?: () => void;
  showBack?: boolean;
}

export const Layout: React.FC<LayoutProps> = ({ children, title, onBack, showBack }) => {
  return (
    <div className="min-h-screen bg-black text-white flex flex-col max-w-md mx-auto relative border-x border-zinc-800 shadow-2xl overflow-hidden">
      <header className="px-6 py-8 flex items-center justify-between z-10">
        <div className="flex items-center gap-4">
          {showBack && (
            <button 
              onClick={onBack}
              className="p-2 -ml-2 rounded-full hover:bg-zinc-900 transition-colors"
            >
              <ChevronLeft className="w-6 h-6 text-[#D4AF37]" />
            </button>
          )}
          {title && <h1 className="text-xl font-bold gold-text">{title}</h1>}
        </div>
        {!title && (
          <div className="flex items-center gap-1">
            <div className="w-8 h-8 rounded-lg bg-[#D4AF37] flex items-center justify-center font-bold text-black text-lg">M</div>
            <span className="font-bold tracking-tight text-xl">oneyVibe</span>
          </div>
        )}
      </header>
      
      <main className="flex-1 overflow-y-auto px-6 pb-20 scrollbar-hide">
        {children}
      </main>

      {/* Decorative background gradients */}
      <div className="absolute top-[-10%] right-[-20%] w-64 h-64 bg-[#D4AF37] opacity-10 rounded-full blur-[100px] pointer-events-none" />
      <div className="absolute bottom-[-10%] left-[-20%] w-64 h-64 bg-[#D4AF37] opacity-5 rounded-full blur-[100px] pointer-events-none" />
    </div>
  );
};
